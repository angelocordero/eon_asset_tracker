import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/providers.dart';
import '../core/utils.dart';
import '../models/inventory_model.dart';
import '../notifiers/categories_notifier.dart';
import '../notifiers/departments_notifier.dart';

part 'notifiers.g.dart';

@Riverpod(keepAlive: true)
class AdvancedInventoryNotifier extends _$AdvancedInventoryNotifier {
  @override
  FutureOr<Inventory> build() async {
    state = const AsyncLoading();

    ref.watch(categoriesNotifierProvider);
    ref.watch(departmentsNotifierProvider);

    MySQLConnection conn = await createSqlConn();
    await conn.connect();

    Inventory inventory = Inventory(
      items: await DatabaseAPI.getInventoryUnfiltered(page: 0, itemsPerPage: ref.watch(itemsPerPageProvider)),
      count: await DatabaseAPI.getTotalInventoryCount(conn),
    );

    if (conn.connected) {
      conn.close();
    }

    return inventory;
  }
}

@riverpod
class ActiveSearchFiltersNotifier extends _$ActiveSearchFiltersNotifier {
  @override
  List<InventorySearchFilter> build() {
    return [];
  }

  void enable(InventorySearchFilter filter) {
    state.add(filter);

    state = List.from(state);
  }

  void disable(InventorySearchFilter filter) {
    state.remove(filter);

    state = List.from(state);
  }
}
