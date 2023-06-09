import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import 'categories_notifier.dart';
import 'departments_notifier.dart';

part 'dashboard_notifiers.g.dart';

@Riverpod(keepAlive: true)
FutureOr<Map<String, int>> dashboardCategories(
    DashboardCategoriesRef ref) async {
  ref.watch(categoriesNotifierProvider);

  return await DatabaseAPI.getCategoriesCount();
}

@Riverpod(keepAlive: true)
FutureOr<Map<String, int>> dashboardDepartments(
    DashboardDepartmentsRef ref) async {
  ref.watch(departmentsNotifierProvider);

  return await DatabaseAPI.getDepartmentsCount();
}

@Riverpod(keepAlive: true)
FutureOr<Map<String, int>> dashboardStatus(DashboardStatusRef ref) async {
  return await DatabaseAPI.getStatusCount();
}
