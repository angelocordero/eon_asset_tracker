import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import 'categories_notifier.dart';
import 'departments_notifier.dart';

part 'dashboard_notifiers.g.dart';

@Riverpod(keepAlive: true)
class DashboardCategoriesNotifier extends _$DashboardCategoriesNotifier {
  @override
  FutureOr<Map<String, int>> build() async {
    ref.watch(categoriesNotifierProvider);

    state = const AsyncLoading();

    return await DatabaseAPI.getCategoriesCount();
  }
}

@Riverpod(keepAlive: true)
class DashboardDepartmentsNotifier extends _$DashboardDepartmentsNotifier {
  @override
  FutureOr<Map<String, int>> build() async {
    ref.watch(departmentsNotifierProvider);

    state = const AsyncLoading();

    return await DatabaseAPI.getDepartmentsCount();
  }
}

@Riverpod(keepAlive: true)
class DashboardStatusNotifier extends _$DashboardStatusNotifier {
  @override
  FutureOr<Map<String, int>> build() async {
    state = const AsyncLoading();

    return await DatabaseAPI.getStatusCount();
  }
}
