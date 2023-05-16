import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/user_model.dart';

class AdminPanelNotifier extends StateNotifier<Map<String, List<dynamic>>> {
  AdminPanelNotifier({
    required this.departments,
    required this.categories,
    required this.ref,
  }) : super(
          {'users': [], 'departments': departments, 'categories': categories},
        );

  final StateNotifierProviderRef<AdminPanelNotifier, Map<String, List<dynamic>>> ref;
  List<Department> departments;
  List<ItemCategory> categories;

  Future<void> init() async {
    state['users'] = await DatabaseAPI.getUsers(departments);
    await DatabaseAPI.refreshDepartmentsAndCategories(ref);
  }

  Future<void> addDepartment(String departmentName) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.addDepartment(departmentName);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      await ref.read(dashboardDataProvider.notifier).refresh();

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> editDepartment(Department department) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.editDepartment(department);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      await ref.read(dashboardDataProvider.notifier).refresh();

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> deleteDepartment(String departmentID) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.deleteDepartment(departmentID);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      await ref.read(dashboardDataProvider.notifier).refresh();

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> addCategory(String categoryName) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.addCategory(categoryName);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      await ref.read(dashboardDataProvider.notifier).refresh();

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> editCategory(ItemCategory category) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.editCategory(category);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      await ref.read(dashboardDataProvider.notifier).refresh();

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> deleteCategory(String categoryID) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.deleteCategory(categoryID);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      await ref.read(dashboardDataProvider.notifier).refresh();

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> addUser(User user, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      EasyLoading.showError('Passwords do not match');
      return;
    }

    EasyLoading.show();
    try {
      await DatabaseAPI.addUser(user, password);

      await ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<void> editUser(User user) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.editUser(user);

      await ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<void> delete(User user) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.deleteUser(user);

      await ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<void> resetPassword(User user, String newPassword) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.resetPassword(user, newPassword);

      await ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }
}
