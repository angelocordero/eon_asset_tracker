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

    await AsyncValue.guard(() async {
      return await DatabaseAPI.addDepartment(departmentName);
    });

    ref.invalidateSelf();
  }

  Future<void> editDepartment(Department department) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      return await DatabaseAPI.editDepartment(department);
    });

    ref.invalidateSelf();
  }

  Future<void> deleteDepartment(String departmentID) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      return await DatabaseAPI.deleteDepartment(departmentID);
    });

    ref.invalidateSelf();
  }
}
