// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/constants.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/department_model.dart';
import '../models/user_model.dart';

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  static final List<String> statusList = [
    'Admin',
    'User',
  ];

  String status = 'User';
  late List<Department> departments;
  late Department department;

  @override
  void initState() {
    departments = ref.read(departmentsProvider);

    department = departments.first;

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
                'A D D   U S E R',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 30,
              ),
              _usernameField(),
              const SizedBox(
                height: 30,
              ),
              _enterPasswordField(),
              const SizedBox(
                height: 30,
              ),
              _confirmPasswordField(),
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

            try {
              User user = User.toDatabase(username: _userNameController.text.trim(), department: department, status: status);

              await ref.read(adminPanelProvider.notifier).addUser(
                    ref,
                    user,
                    _passwordController.text.trim(),
                    _confirmPasswordController.text.trim(),
                  );

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } catch (e, st) {
              showErrorAndStacktrace(e, st);
            }
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
              value: departments.first,
              items: departments.map<DropdownMenuItem<Department>>((value) => DropdownMenuItem<Department>(value: value, child: Text(value.departmentName))).toList(),
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

  Column _enterPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Password'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(hintText: '(required)'),
          ),
        ),
      ],
    );
  }

  Column _confirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Confirm Password'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: TextField(
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            obscureText: true,
            controller: _confirmPasswordController,
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
              value: 'User',
              items: statusList.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (String? newStatus) {
                if (newStatus == null) return;
                setState(() {
                  status = newStatus;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
