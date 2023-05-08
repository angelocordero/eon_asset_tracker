import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:eon_asset_tracker/notifiers/dashboard_notifier.dart';
import 'package:eon_asset_tracker/notifiers/inventory_notifier.dart';
import 'package:mysql1/mysql1.dart';
import 'package:riverpod/riverpod.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

final sqlConnProvider = StateProvider<MySqlConnection?>((ref) {
  return null;
});

final departmentsProvider = StateProvider<List<Department>>((ref) {
  return [];
});

final categoriesProvider = StateProvider<List<ItemCategory>>((ref) {
  return [];
});

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<Item>>((ref) {
  return InventoryNotifier(ref);
});

final selectedItemProvider = StateProvider<Item?>((ref) {
  List<Item> items = ref.watch(inventoryProvider);

  if (items.isNotEmpty) {
    return items.first;
  }

  return null;
});

final appbarTitleProvider = StateProvider<String>((ref) {
  return 'Home';
});

final searchQueryProvider = StateProvider<String>((ref) {
  return 'Asset ID';
});

final totalItemsProvider = StateProvider<int>((ref) {
  return 0;
});

final dashboardDataProvider =
    StateNotifierProvider<DashboardNotifier, DashboardData>((ref) {
  return DashboardNotifier(
    conn: ref.watch(sqlConnProvider),
    departments: ref.watch(departmentsProvider),
    categories: ref.watch(categoriesProvider),
  );
});
