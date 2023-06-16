import 'package:eon_asset_tracker/core/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../models/department_model.dart';

part 'departments_notifier.g.dart';

@Riverpod(keepAlive: true)
class DepartmentsNotifier extends _$DepartmentsNotifier {
  @override
  FutureOr<List<Department>> build() async {
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
  }

  Future<void> editDepartment(Department department) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.editDepartment(department);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }

  Future<void> deleteDepartment(String departmentID) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseAPI.deleteDepartment(departmentID);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }
}
