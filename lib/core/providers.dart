import 'package:eon_asset_tracker/models/department_model.dart';
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
  return null;
});
