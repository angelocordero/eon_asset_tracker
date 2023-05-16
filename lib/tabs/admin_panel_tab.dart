import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/models/category_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:eon_asset_tracker/screens/add_user_screen.dart';
import 'package:eon_asset_tracker/screens/reset_password_screen.dart';
import 'package:eon_asset_tracker/widgets/admin_panel_prompt.dart';
import 'package:eon_asset_tracker/widgets/admin_panel_users_list.dart';
import 'package:eon_asset_tracker/widgets/master_password_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database_api.dart';
import '../models/user_model.dart';
import '../screens/edit_user_screen.dart';
import '../widgets/admin_panel_search_widget.dart';

class AdminPanelTab extends ConsumerWidget {
  const AdminPanelTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print((ref.watch(adminPanelProvider)['departments'])!.length);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Visibility(
        visible: false,
        replacement: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AdminPanelSearchWidget(),
            const Divider(
              height: 40,
            ),
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
                onPressed: () async {
                  try {
                    User? user = ref.read(adminPanelSelectedUserProvider);

                    if (user == null) return;

                    await ref.read(adminPanelProvider.notifier).delete(user);
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
                                      return const ResetPasswordScreen();
                                    },
                                  ),
                                );
                              } else {
                                showErrorAndStacktrace('Password is not an admin password', null);
                              }
                            } catch (e, st) {
                              showErrorAndStacktrace(e, st);
                            }
                          },
                        );
                      },
                    ),
                  );
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
              itemCount: categories.length,
              itemBuilder: (context, index) {
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
                              TextEditingController controller = TextEditingController();

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

                                        await ref.read(adminPanelProvider.notifier).editCategory(category);
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
                              await showDeleteCategoryDialog(context, ref, category.categoryID);
                            },
                            icon: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                    if (index + 1 != categories.length) const Divider(),
                  ],
                );
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
                  TextEditingController controller = TextEditingController();

                  Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) {
                        return AdminPanelPrompt(
                          title: 'Add Category',
                          controller: controller,
                          callback: () async {
                            await ref.read(adminPanelProvider.notifier).addCategory(controller.text.trim());
                            // ignore: use_build_context_synchronously
                            // Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
                child: const Text('A D D'),
              ),
            ],
          ),
        ],
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
              onPressed: () {
                Navigator.pop(context);

                ref.read(adminPanelProvider.notifier).deleteDepartment(departmentID);
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
              onPressed: () {
                Navigator.pop(context);

                ref.read(adminPanelProvider.notifier).deleteCategory(categoryID);
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
              itemCount: departments.length,
              itemBuilder: (context, index) {
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
                              TextEditingController controller = TextEditingController();

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

                                        await ref.read(adminPanelProvider.notifier).editDepartment(department);
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
                    if (index + 1 != departments.length) const Divider(),
                  ],
                );
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
                  TextEditingController controller = TextEditingController();

                  Navigator.push(
                    context,
                    CustomRoute(
                      builder: (context) {
                        return AdminPanelPrompt(
                          title: 'Add Department',
                          controller: controller,
                          callback: () async {
                            await ref.read(adminPanelProvider.notifier).addDepartment(controller.text.trim());
                            // ignore: use_build_context_synchronously
                            //Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
                child: const Text('A D D'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}