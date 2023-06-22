import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/utils.dart';
import '../models/department_model.dart';

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
