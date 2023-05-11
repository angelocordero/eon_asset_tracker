import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:eon_asset_tracker/notifiers/dashboard_notifier.dart';
import 'package:eon_asset_tracker/notifiers/inventory_notifier.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:riverpod/riverpod.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';

final sqlConnProvider = StateProvider<MySQLConnection?>((ref) => null);

final userProvider = StateProvider<User?>((ref) => null);

final departmentsProvider = StateProvider<List<Department>>((ref) => []);

final categoriesProvider = StateProvider<List<ItemCategory>>((ref) => []);

final inventoryProvider = StateNotifierProvider<InventoryNotifier, List<Item>>((ref) {
  return InventoryNotifier(
    conn: ref.watch(sqlConnProvider),
    departments: ref.watch(departmentsProvider),
    categories: ref.watch(categoriesProvider),
  );
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

final dashboardDataProvider = StateNotifierProvider<DashboardNotifier, DashboardData>((ref) {
  return DashboardNotifier(
    conn: ref.watch(sqlConnProvider),
    departments: ref.watch(departmentsProvider),
    categories: ref.watch(categoriesProvider),
  );
});

final checkedItemProvider = StateProvider<List<String>>((ref) => []);
