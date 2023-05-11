import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client/mysql_client.dart';

import '../core/database_api.dart';
import '../models/category_model.dart';
import '../models/department_model.dart';

class DashboardNotifier extends StateNotifier<DashboardData> {
  DashboardNotifier({
    required this.conn,
    required this.departments,
    required this.categories,
  }) : super(DashboardData.empty());

  MySqlConnection? conn;
  List<Department> departments;
  List<ItemCategory> categories;

  bool _isLoading = true;

  set loading(bool state) {
    _isLoading = state;
  }

  get isLoading => _isLoading;

  Future<void> init() async {
    if (conn == null) return;

    state = await _setState();
  }

  Future<DashboardData> _setState() async {
    _isLoading = true;

    DashboardData dashboardData = DashboardData(
      statusDashboardData: await DatabaseAPI.statusData(conn: conn),
      categoriesDashbordData: await DatabaseAPI.categoriesData(
        conn: conn,
        categories: categories,
      ),
      departmentsDashboardData: await DatabaseAPI.departmentsData(
        conn: conn,
        departments: departments,
      ),
      totalItems: await DatabaseAPI.getTotal(conn: conn),
    );

    await Future.delayed(
      const Duration(seconds: 1),
    );

    _isLoading = false;
    return dashboardData;
  }

  refresh() async {
    if (conn == null) return;

    _isLoading = true;

    state = DashboardData.empty();

    await Future.delayed(const Duration(milliseconds: 200));

    state = await _setState();
  }
}
