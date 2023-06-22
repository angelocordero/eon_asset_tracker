import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../inventory_advanced_search/advanced_inventory_notifier.dart';
import '../inventory_advanced_search/notifiers.dart';
import '../models/department_model.dart';
import 'admin_panel_users_notifier.dart';

part 'departments_notifier.g.dart';

@Riverpod(keepAlive: true)
class DepartmentsNotifier extends _$DepartmentsNotifier {
  @override
  FutureOr<List<Department>> build() async {
    state = const AsyncLoading();

    return await DatabaseAPI.getDepartments();
  }

  Future<void> addDepartment(String departmentName) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.addDepartment(departmentName);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
    ref.invalidate(currentInventoryPage);
    ref.invalidate(advancedInventoryNotifierProvider);
    ref.invalidate(adminPanelUsersNotifierProvider);
  }

  Future<void> editDepartment(Department department) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.editDepartment(department);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
    ref.invalidate(currentInventoryPage);
    ref.invalidate(advancedInventoryNotifierProvider);
    ref.invalidate(adminPanelUsersNotifierProvider);
  }

  Future<void> deleteDepartment(String departmentID) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.deleteDepartment(departmentID);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
    ref.invalidate(activeSearchFiltersNotifierProvider);
    ref.invalidate(advancedSearchDataNotifierProvider);
    ref.invalidate(isAdvancedFilterNotifierProvider);
    ref.invalidate(currentInventoryPage);
    ref.invalidate(advancedInventoryNotifierProvider);
    ref.invalidate(adminPanelUsersNotifierProvider);
  }
}
