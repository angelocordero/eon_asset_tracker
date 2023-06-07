// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/user_model.dart';

class AdminPanelNotifier extends StateNotifier<Map<String, List<dynamic>>> {
  AdminPanelNotifier({
    required this.departments,
    required this.categories,
  }) : super(
          {'users': [], 'departments': departments, 'categories': categories},
        ) {
    init();
  }

  List<Department> departments;
  List<ItemCategory> categories;

  void init() async {
    state['users'] = await DatabaseAPI.getUsers();
    state = Map<String, List<dynamic>>.from(state);
  }

  Future<void> addDepartment(WidgetRef ref, String departmentName) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.addDepartment(departmentName);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> editDepartment(WidgetRef ref, Department department) async {
    try {
      await DatabaseAPI.editDepartment(department);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> deleteDepartment(WidgetRef ref, String departmentID) async {
    try {
      await DatabaseAPI.deleteDepartment(departmentID);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> addCategory(WidgetRef ref, String categoryName) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.addCategory(categoryName);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);

      EasyLoading.dismiss();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> editCategory(WidgetRef ref, ItemCategory category) async {
    try {
      await DatabaseAPI.editCategory(category);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> deleteCategory(WidgetRef ref, String categoryID) async {
    try {
      await DatabaseAPI.deleteCategory(categoryID);

      await DatabaseAPI.refreshDepartmentsAndCategories(ref);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }
  }

  Future<void> addUser(WidgetRef ref, User user, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      EasyLoading.showError('Passwords do not match');
      return;
    }

    EasyLoading.show();
    try {
      await DatabaseAPI.addUser(user, password);

      ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }

  Future<void> editUser(WidgetRef ref, User user) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.editUser(user);

      ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }

  Future<void> delete(WidgetRef ref, User user) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.deleteUser(user);

      ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }

  Future<void> resetPassword(WidgetRef ref, User user, String newPassword) async {
    EasyLoading.show();
    try {
      await DatabaseAPI.resetPassword(user, newPassword);

      ref.read(adminPanelProvider.notifier).init();

      EasyLoading.dismiss();
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }
}
