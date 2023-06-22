import 'package:mysql_client/mysql_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/inventory_model.dart';
import '../notifiers/categories_notifier.dart';
import '../notifiers/departments_notifier.dart';
import 'advanced_database_api.dart';
import 'notifiers.dart';

part 'advanced_inventory_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdvancedInventoryNotifier extends _$AdvancedInventoryNotifier {
  @override
  FutureOr<Inventory> build() async {
    ref.watch(categoriesNotifierProvider);
    ref.watch(departmentsNotifierProvider);

    state = const AsyncLoading();

    ref.invalidate(tableSortingProvider);

    return _getUnfilteredInventory(
      0,
      ref.watch(itemsPerPageProvider),
    );
  }

  Future<void> getInventory() async {
    int page = ref.read(currentInventoryPage);
    int itemsPerPage = ref.read(itemsPerPageProvider);

    bool searching = ref.read(isAdvancedFilterNotifierProvider);

    if (searching) {
      state = await AsyncValue.guard(() async => await _getAdvancedFilteredInvetory(page, itemsPerPage));
    } else {
      state = await AsyncValue.guard(() async => await _getUnfilteredInventory(page, itemsPerPage));
    }

    ref.invalidate(tableSortingProvider);
  }

  Future<Inventory> _getUnfilteredInventory(int page, int itemsPerPage) async {
    MySQLConnection conn = await createSqlConn();
    await conn.connect();

    Inventory inventory = Inventory(
      items: await DatabaseAPI.getInventoryUnfiltered(
        page: page,
        itemsPerPage: itemsPerPage,
      ),
      count: await DatabaseAPI.getTotalInventoryCount(conn),
    );

    if (conn.connected) {
      await conn.close();
    }

    return inventory;
  }

  Future<Inventory> _getAdvancedFilteredInvetory(int page, int itemsPerPage) async {
    MySQLConnection conn = await createSqlConn();
    await conn.connect();

    Inventory inventory = await AdvancedDatabaseAPI.advancedSearch(
      conn: conn,
      page: page,
      itemsPerPage: itemsPerPage,
      searchData: ref.read(advancedSearchDataNotifierProvider),
      filters: ref.read(activeSearchFiltersNotifierProvider),
    );

    if (conn.connected) {
      await conn.close();
    }

    return inventory;
  }
}
