import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database_api.dart';
import '../models/category_model.dart';
import '../models/department_model.dart';

class DashboardNotifier extends StateNotifier<DashboardData> {
  DashboardNotifier({
    required this.ref,
    required this.departments,
    required this.categories,
  }) : super(DashboardData.empty());

  List<Department> departments;
  List<ItemCategory> categories;

  StateNotifierProviderRef<DashboardNotifier, DashboardData> ref;

  bool _isLoading = true;

  set loading(bool state) {
    _isLoading = state;
  }

  get isLoading => _isLoading;

  Future<void> init() async {
    state = await _setState();
  }

  Future<DashboardData> _setState() async {
    _isLoading = true;

    DashboardData dashboardData = await DatabaseAPI.initDashboard(ref);

    await Future.delayed(
      const Duration(seconds: 1),
    );

    _isLoading = false;
    return dashboardData;
  }

  refresh() async {
    _isLoading = true;

    state = DashboardData.empty();

    await Future.delayed(const Duration(milliseconds: 200));

    state = await _setState();
  }
}
