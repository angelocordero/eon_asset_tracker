import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../models/department_model.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';
import '../notifiers/admin_panel_users_notifier.dart';
import '../notifiers/departments_notifier.dart';
import '../notifiers/properties_notifier.dart';

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

  late List<Property> properties;
  late Property property;

  @override
  void initState() {
    departments = ref.read(departmentsNotifierProvider).requireValue;
    properties = ref.read(propertiesNotifierProvider).requireValue;

    department = departments.first;
    property = properties.first;

    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: 800,
          height: 600,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _usernameField(),
                          const SizedBox(height: 30),
                          _propertyField(),
                          const SizedBox(height: 30),
                          _enterPasswordField(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _statusField(),
                          const SizedBox(height: 50),
                          _departmentField(),
                          const SizedBox(height: 30),
                          _confirmPasswordField(),
                        ],
                      ),
                    ),
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
            if (_userNameController.text.trim().isEmpty ||
                _passwordController.text.trim().isEmpty ||
                _confirmPasswordController.text.trim().isEmpty) {
              EasyLoading.showError('Required fields must not be empty');
              return;
            }

            try {
              User user = User.toDatabase(
                username: _userNameController.text.trim(),
                department: department,
                status: status,
                property: property,
              );

              await ref.read(adminPanelUsersNotifierProvider.notifier).addUser(
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
          width: 300,
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
                  .map<DropdownMenuItem<Department>>((value) => DropdownMenuItem<Department>(value: value, child: Text(value.departmentName)))
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

  Column _propertyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Property'),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<Property>(
              isDense: true,
              isExpanded: true,
              focusColor: Colors.transparent,
              borderRadius: defaultBorderRadius,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: defaultBorderRadius,
                ),
              ),
              value: property,
              items: properties
                  .map<DropdownMenuItem<Property>>((value) => DropdownMenuItem<Property>(value: value, child: Text(value.propertyName)))
                  .toList(),
              onChanged: (Property? newProperty) {
                if (newProperty == null) return;
                setState(() {
                  property = newProperty;
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
