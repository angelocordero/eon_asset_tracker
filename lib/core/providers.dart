import 'package:riverpod/riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import '../models/item_model.dart';
import '../models/user_model.dart';
import '../notifiers/admin_panel_users_notifier.dart';
import '../notifiers/inventory_notifier.dart';
import 'constants.dart';

final tableSortingProvider = StateProvider<TableSort>((ref) {
  return (tableColumn: null, sortOrder: null);
});

final userProvider = StateProvider<User?>((ref) => null);

final itemsPerPageProvider = StateProvider<int>((ref) => 50);

final selectedItemProvider = StateProvider<Item?>((ref) {
  List<Item>? items = ref.watch(inventoryNotifierProvider).asData?.valueOrNull?.items;

  if (items != null && items.isNotEmpty) {
    return items.first;
  }

  return null;
});

final appbarTitleProvider = StateProvider.autoDispose<String>((ref) {
  return 'HOME';
});

final searchFilterProvider = StateProvider<InventorySearchFilter>((ref) {
  return InventorySearchFilter.assetID;
});

final searchQueryProvider = StateProvider<dynamic>((ref) => '');

final checkedItemProvider = StateProvider<List<String>>((ref) {
  ref.watch(inventoryNotifierProvider);

  return [];
});

final currentInventoryPage = StateProvider<int>((ref) => 0);

final sidebarControllerProvider = StateProvider<SidebarXController>((ref) {
  return SidebarXController(selectedIndex: 0);
});

final adminPanelSelectedUserProvider = StateProvider<User?>((ref) {
  List<User>? users = ref.watch(adminPanelUsersNotifierProvider).whenOrNull(
        data: (data) => data,
      );

  if (users == null) {
    return null;
  }

  if (users.isNotEmpty) {
    return users.first;
  }

  return null;
});
