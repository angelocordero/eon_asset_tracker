// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/custom_route.dart';
import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/user_model.dart';
import '../screens/add_user_screen.dart';
import '../screens/edit_user_screen.dart';
import '../screens/reset_password_screen.dart';
import '../widgets/admin_panel_prompt.dart';
import '../widgets/admin_panel_users_list.dart';
import '../widgets/master_password_prompt.dart';

class AdminPanelTab extends ConsumerWidget {
  const AdminPanelTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Visibility(
        visible: false,
        replacement: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const AdminPanelSearchWidget(),
            // const Divider(
            //   height: 40,
            // ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _usersList(context, ref),
                  const VerticalDivider(
                    width: 40,
                  ),
                  _departmentsList(context, ref),
                  const VerticalDivider(
                    width: 40,
                  ),
                  _categoriesList(context, ref),
                ],
              ),
            ),
          ],
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Expanded _usersList(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          const Text('U S E R S'),
          const Divider(
            height: 40,
          ),
          const Expanded(
            child: AdminPanelUsersList(),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) {
                        return const AddUserScreen();
                      },
                    ),
                  );
                },
                child: const Text('A D D'),
              ),
              TextButton(
                onPressed: ref.watch(adminPanelSelectedUserProvider) == ref.watch(userProvider)
                    ? null
                    : () async {
                        User? user = ref.read(adminPanelSelectedUserProvider);
                        if (user == null) return;

                        try {
                          if (user.isAdmin) {
                            TextEditingController controller = TextEditingController();

                            Navigator.push(
                              context,
                              CustomRoute(
                                builder: (context) {
                                  return MasterPasswordPrompt(
                                    controller: controller,
                                    callback: () async {
                                      bool admin = await DatabaseAPI.getMasterPassword(controller.text.trim());

                                      if (admin) {
                                        await ref.read(adminPanelProvider.notifier).delete(ref, user);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      } else {
                                        showErrorAndStacktrace('Wrong master password', null);
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            await ref.read(adminPanelProvider.notifier).delete(ref, user);
                          }
                        } catch (e, st) {
                          showErrorAndStacktrace(e, st);
                        }
                      },
                child: const Text('D E L E T E'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) {
                        return const EditUserScreen();
                      },
                    ),
                  );
                },
                child: const Text('E D I T'),
              ),
              TextButton(
                onPressed: () async {
                  if (ref.read(userProvider)!.isAdmin && !ref.read(adminPanelSelectedUserProvider)!.isAdmin) {
                    Navigator.push(
                      context,
                      CustomRoute(
                        builder: (context) {
                          return ResetPasswordScreen(
                            passwordController: TextEditingController(),
                            confirmPasswordController: TextEditingController(),
                          );
                        },
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      CustomRoute(
                        builder: (context) {
                          TextEditingController masterPasswordController = TextEditingController();

                          return MasterPasswordPrompt(
                            controller: masterPasswordController,
                            callback: () async {
                              try {
                                //get masterpassword
                                bool admin = await DatabaseAPI.getMasterPassword(masterPasswordController.text.trim());

                                if (admin) {
                                  // ignore: use_build_context_synchronously
                                  await Navigator.push(
                                    context,
                                    CustomRoute(
                                      builder: (context) {
                                        return ResetPasswordScreen(
                                          passwordController: TextEditingController(),
                                          confirmPasswordController: TextEditingController(),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  showErrorAndStacktrace('Wrong master password', null);
                                }
                              } catch (e, st) {
                                showErrorAndStacktrace(e, st);
                              }
                            },
                          );
                        },
                      ),
                    );
                  }
                },
                child: const Text('R E S E T   P A S S W O R D'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Expanded _categoriesList(BuildContext context, WidgetRef ref) {
    List<ItemCategory> categories = ref.watch(adminPanelProvider.select((value) => List<ItemCategory>.from(value['categories']!)));

    return Expanded(
      child: Column(
        children: [
          const Text('C A T E G O R I E S'),
          const Divider(
            height: 40,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index < categories.length) {
                  ItemCategory category = categories[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(category.categoryName),
                        leading: Text('${(index + 1).toString()}.'),
                        trailing: Wrap(
                          children: [
                            IconButton.outlined(
                              onPressed: () {
                                TextEditingController controller = TextEditingController.fromValue(TextEditingValue(text: category.categoryName));

                                Navigator.push(
                                  context,
                                  CustomRoute(
                                    builder: (context) {
                                      return AdminPanelPrompt(
                                        title: 'Edit Category',
                                        controller: controller,
                                        callback: () async {
                                          if (controller.text.trim().isEmpty) return;

                                          category = category.copyWith(
                                            categoryName: controller.text.trim(),
                                          );

                                          await ref.read(adminPanelProvider.notifier).editCategory(ref, category);
                                          await DatabaseAPI.refreshDepartmentsAndCategories(ref);

                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton.outlined(
                              onPressed: () async {
                                await showDeleteCategoryDialog(context, ref, category.categoryID!);
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                } else {
                  return ListTile(
                    title: const Text(
                      'A D D',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      await _addCategory(context, ref);
                    },
                  );
                }
              },
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () async {
                  await _addCategory(context, ref);
                },
                child: const Text('A D D'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    TextEditingController controller = TextEditingController();

    await Navigator.push(
      context,
      CustomRoute(
        builder: (context) {
          return AdminPanelPrompt(
            title: 'Add Category',
            controller: controller,
            callback: () async {
              await ref.read(adminPanelProvider.notifier).addCategory(ref, controller.text.trim());
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Future<dynamic> showDeleteDepartmentDialog(
    BuildContext context,
    WidgetRef ref,
    String departmentID,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete?'),
          actions: [
            IconButton.outlined(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            IconButton.outlined(
              onPressed: () async {
                Navigator.pop(context);

                await ref.read(adminPanelProvider.notifier).deleteDepartment(ref, departmentID);
                await DatabaseAPI.refreshDepartmentsAndCategories(ref);
              },
              icon: const Icon(Icons.check),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showDeleteCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    String categoryID,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete?'),
          actions: [
            IconButton.outlined(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            IconButton.outlined(
              onPressed: () async {
                Navigator.pop(context);

                await ref.read(adminPanelProvider.notifier).deleteCategory(ref, categoryID);
                await DatabaseAPI.refreshDepartmentsAndCategories(ref);
              },
              icon: const Icon(Icons.check),
            ),
          ],
        );
      },
    );
  }

  Expanded _departmentsList(BuildContext context, WidgetRef ref) {
    List<Department> departments = ref.watch(adminPanelProvider.select((value) => List<Department>.from(value['departments']!)));

    return Expanded(
      child: Column(
        children: [
          const Text('D E P A R T M E N T S'),
          const Divider(
            height: 40,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: departments.length + 1,
              itemBuilder: (context, index) {
                if (index < departments.length) {
                  Department department = departments[index];

                  return Column(
                    children: [
                      ListTile(
                        title: Text(department.departmentName),
                        leading: Text('${(index + 1).toString()}.'),
                        trailing: Wrap(
                          children: [
                            IconButton.outlined(
                              onPressed: () {
                                TextEditingController controller = TextEditingController.fromValue(TextEditingValue(text: department.departmentName));

                                Navigator.push(
                                  context,
                                  CustomRoute(
                                    builder: (context) {
                                      return AdminPanelPrompt(
                                        title: 'Edit Department',
                                        controller: controller,
                                        callback: () async {
                                          if (controller.text.trim().isEmpty) return;

                                          department = department.copyWith(
                                            departmentName: controller.text.trim(),
                                          );

                                          await ref.read(adminPanelProvider.notifier).editDepartment(ref, department);
                                          await DatabaseAPI.refreshDepartmentsAndCategories(ref);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton.outlined(
                              onPressed: () async {
                                await showDeleteDepartmentDialog(context, ref, department.departmentID);
                              },
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                } else {
                  return ListTile(
                    title: const Text(
                      'A D D',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      await _addDepartment(context, ref);
                    },
                  );
                }
              },
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () async {
                  _addDepartment(context, ref);
                },
                child: const Text('A D D'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addDepartment(BuildContext context, WidgetRef ref) async {
    TextEditingController controller = TextEditingController();

    await Navigator.push(
      context,
      CustomRoute(
        builder: (context) {
          return AdminPanelPrompt(
            title: 'Add Department',
            controller: controller,
            callback: () async {
              await ref.read(adminPanelProvider.notifier).addDepartment(ref, controller.text.trim());
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
