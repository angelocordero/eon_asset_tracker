import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/custom_route.dart';
import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/department_model.dart';
import '../models/user_model.dart';
import '../notifiers/admin_panel_users_notifier.dart';
import '../notifiers/departments_notifier.dart';
import '../widgets/master_password_prompt.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  const EditUserScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  late final TextEditingController _userNameController;

  static final List<String> statusList = [
    'Admin',
    'User',
  ];

  late String status;
  late List<Department> departments;
  late Department department;

  @override
  void initState() {
    User user = ref.read(adminPanelSelectedUserProvider)!;

    departments = ref.read(departmentsNotifierProvider).requireValue;

    department = user.department ?? departments.first;

    status = user.isAdmin ? 'Admin' : 'User';

    _userNameController =
        TextEditingController.fromValue(TextEditingValue(text: user.username));

    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'E D I T   U S E R',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 30,
              ),
              _usernameField(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _departmentField(),
                  const SizedBox(
                    width: 30,
                  ),
                  _statusField(),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              _buttons(context)
            ],
          ),
        ),
      ),
    );
  }

  Row _buttons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_userNameController.text.trim().isEmpty) {
              EasyLoading.showError('Required fields must not be empty');
              return;
            }

            User user = ref.read(adminPanelSelectedUserProvider)!;

            bool isAdmin = user.isAdmin;

            user = User(
              userID: user.userID,
              username: _userNameController.text.trim(),
              isAdmin: status == 'Admin' ? true : false,
              department: department,
            );

            if (isAdmin) {
              await Navigator.push(
                context,
                CustomRoute(
                  builder: (context) {
                    TextEditingController controller = TextEditingController();
                    return MasterPasswordPrompt(
                      controller: controller,
                      callback: () async {
                        try {
                          //get masterpassword
                          bool admin = await DatabaseAPI.getMasterPassword(
                              controller.text.trim());

                          if (admin) {
                            await ref
                                .read(adminPanelUsersNotifierProvider.notifier)
                                .editUser(user);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          } else {
                            showErrorAndStacktrace(
                                'Password is not an admin password', null);
                          }
                        } catch (e, st) {
                          showErrorAndStacktrace(e, st);
                        }
                      },
                    );
                  },
                ),
              );
            } else {
              try {
                await ref
                    .read(adminPanelUsersNotifierProvider.notifier)
                    .editUser(user);
              } catch (e, st) {
                showErrorAndStacktrace(e, st);
              }
            }

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  Column _departmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Department'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 200,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<Department>(
              isDense: true,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: department,
              items: departments
                  .map<DropdownMenuItem<Department>>((value) =>
                      DropdownMenuItem<Department>(
                          value: value, child: Text(value.departmentName)))
                  .toList(),
              onChanged: (Department? newDepartment) {
                if (newDepartment == null) return;
                setState(() {
                  department = newDepartment;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _usernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            controller: _userNameController,
            decoration: const InputDecoration(hintText: '(required)'),
          ),
        ),
      ],
    );
  }

  Column _statusField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 200,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              isDense: true,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: status,
              items: statusList
                  .map<DropdownMenuItem<String>>((value) =>
                      DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                  .toList(),
              onChanged: ref.watch(adminPanelSelectedUserProvider) ==
                      ref.watch(userProvider)
                  ? null
                  : (String? newStatus) {
                      if (newStatus == null) return;
                      setState(
                        () {
                          status = newStatus;
                        },
                      );
                    },
            ),
          ),
        ),
      ],
    );
  }
}
