// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/custom_route.dart';
import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/user_model.dart';
import '../notifiers/admin_panel_users_notifier.dart';
import '../notifiers/categories_notifier.dart';
import '../notifiers/departments_notifier.dart';
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
        replacement: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _usersList(context, ref),
            const VerticalDivider(
              width: 40,
            ),
            Expanded(child: _departmentsList(context, ref)),
            const VerticalDivider(
              width: 40,
            ),
            Expanded(
              child: _categoriesList(context, ref),
            ),
          ],
        ),
        child: const CircularProgressIndicator(),
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
                EasyLoading.show();

                await ref.read(departmentsNotifierProvider.notifier).deleteDepartment(departmentID);

                Navigator.pop(context);

                EasyLoading.dismiss();
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
    await showDialog(
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
                EasyLoading.show();

                await ref.read(categoriesNotifierProvider.notifier).deleteCategory(categoryID);

                Navigator.pop(context);

                EasyLoading.dismiss();
              },
              icon: const Icon(Icons.check),
            ),
          ],
        );
      },
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
                                        await ref.read(adminPanelUsersNotifierProvider.notifier).deleteUser(user);
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
                            await ref.read(adminPanelUsersNotifierProvider.notifier).deleteUser(user);
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

  Widget _categoriesList(BuildContext context, WidgetRef ref) => ref.watch(categoriesNotifierProvider).when(
        data: (List<ItemCategory> categories) {
          return Column(
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
                                            title: 'E D I T   C A T E G O R Y',
                                            controller: controller,
                                            callback: () async {
                                              EasyLoading.show();
                                              if (controller.text.trim().isEmpty) return;

                                              category = category.copyWith(
                                                categoryName: controller.text.trim(),
                                              );

                                              await ref.read(categoriesNotifierProvider.notifier).editCategory(category);

                                              Navigator.pop(context);

                                              EasyLoading.dismiss();
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
                                    await showDeleteCategoryDialog(
                                      context,
                                      ref,
                                      category.categoryID!,
                                    );
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
          );
        },
        error: (e, st) => Center(
          child: Text(
            e.toString(),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    TextEditingController controller = TextEditingController();

    await Navigator.push(
      context,
      CustomRoute(
        builder: (context) {
          return AdminPanelPrompt(
            title: 'A D D   C A T E G O R Y',
            controller: controller,
            callback: () async {
              await ref.read(categoriesNotifierProvider.notifier).addCategory(controller.text.trim());
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Widget _departmentsList(BuildContext context, WidgetRef ref) => ref.watch(departmentsNotifierProvider).when(
        data: (List<Department> departments) {
          return Column(
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
                                            title: 'E D I T   D E P A R T M E N T',
                                            controller: controller,
                                            callback: () async {
                                              if (controller.text.trim().isEmpty) return;

                                              EasyLoading.show();

                                              department = department.copyWith(
                                                departmentName: controller.text.trim(),
                                              );

                                              await ref.read(departmentsNotifierProvider.notifier).editDepartment(department);

                                              EasyLoading.dismiss();
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
          );
        },
        error: (e, st) => Center(
          child: Text(
            e.toString(),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );

  Future<void> _addDepartment(BuildContext context, WidgetRef ref) async {
    TextEditingController controller = TextEditingController();

    await Navigator.push(
      context,
      CustomRoute(
        builder: (context) {
          return AdminPanelPrompt(
            title: 'A D D   D E P A R T M E N T',
            controller: controller,
            callback: () async {
              await ref.read(departmentsNotifierProvider.notifier).addDepartment(controller.text.trim());
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
