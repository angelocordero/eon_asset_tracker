import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:eon_asset_tracker/notifiers/admin_panel_notifier.dart';
import 'package:eon_asset_tracker/notifiers/dashboard_notifier.dart';
import 'package:eon_asset_tracker/notifiers/inventory_notifier.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import '../models/category_model.dart';
import '../models/inventory_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';

final userProvider = StateProvider<User?>((ref) => null);

final departmentsProvider = StateProvider<List<Department>>((ref) => []);

final categoriesProvider = StateProvider<List<ItemCategory>>((ref) => []);

final selectedItemProvider = StateProvider<Item?>((ref) {
  List<Item> items = ref.watch(inventoryProvider).items;

  if (items.isNotEmpty) {
    return items.first;
  }

  return null;
});

final appbarTitleProvider = StateProvider<String>((ref) {
  return 'Home';
});

final searchFilterProvider = StateProvider<InventorySearchFilter>((ref) {
  return InventorySearchFilter.assetID;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final checkedItemProvider = StateProvider<List<String>>((ref) => []);

final currentInventoryPage = StateProvider<int>((ref) => 0);

final dashboardDataProvider = StateNotifierProvider<DashboardNotifier, DashboardData>((ref) {
  return DashboardNotifier(
    ref: ref,
  );
});

final inventoryProvider = StateNotifierProvider<InventoryNotifier, Inventory>((ref) {
  return InventoryNotifier();
});

final adminPanelProvider = StateNotifierProvider<AdminPanelNotifier, Map<String, List<dynamic>>>((ref) {
  return AdminPanelNotifier(
    departments: ref.watch(departmentsProvider),
    categories: ref.watch(categoriesProvider),
  );
});

final tabSwitcherIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final sidebarControllerProvider = StateProvider<SidebarXController>((ref) {
  return SidebarXController(selectedIndex: 0);
});

final adminPanelSelectedUserProvider = StateProvider<User?>((ref) {
  List<User> users = List<User>.from(ref.watch(adminPanelProvider)['users']!);

  if (users.isNotEmpty) {
    return users.first;
  }

  return null;
});
