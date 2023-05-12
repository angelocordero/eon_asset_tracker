import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:eon_asset_tracker/notifiers/dashboard_notifier.dart';
import 'package:eon_asset_tracker/notifiers/inventory_notifier.dart';
import 'package:riverpod/riverpod.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';

final userProvider = StateProvider<User?>((ref) => null);

final departmentsProvider = StateProvider<List<Department>>((ref) => []);

final categoriesProvider = StateProvider<List<ItemCategory>>((ref) => []);

final inventoryProvider = StateNotifierProvider<InventoryNotifier, List<Item>>((ref) {
  return InventoryNotifier(
    ref: ref,
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

final searchFilterProvider = StateProvider<String>((ref) {
  return 'Asset ID';
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final dashboardDataProvider = StateNotifierProvider<DashboardNotifier, DashboardData>((ref) {
  return DashboardNotifier(
    ref: ref,
    departments: ref.watch(departmentsProvider),
    categories: ref.watch(categoriesProvider),
  );
});

final checkedItemProvider = StateProvider<List<String>>((ref) => []);

final currentInventoryPage = StateProvider<int>((ref) => 0);

final queryResultItemCount = StateProvider<int>((ref) => 0);
