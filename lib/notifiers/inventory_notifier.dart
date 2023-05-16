import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/inventory_model.dart';

class InventoryNotifier extends StateNotifier<Inventory> {
  InventoryNotifier() : super(Inventory.empty()) {
    refresh();
  }

  bool _isLoading = true;

  set loading(bool state) {
    _isLoading = state;
  }

  get isLoading => _isLoading;

  Future<void> initUnfilteredInventory() async {
    _isLoading = true;

    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      state = state.copyWith(items: await DatabaseAPI.getInventoryUnfiltered(0), count: await DatabaseAPI.getTotalInventoryCount(conn));
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    } finally {
      _isLoading = false;
      conn?.close();
    }
  }

  Future<void> initFilteredInventory(String query, InventorySearchFilter filter) async {
    _isLoading = true;

    state = state.copyWith(
      items: await DatabaseAPI.searchInventory(query: query, filter: filter, page: 0),
      count: await DatabaseAPI.getSearchResultTotalCount(query: query, filter: filter),
    );

    _isLoading = false;
  }

  Future<void> getInventoryFromPage({required int page, String? query, InventorySearchFilter? filter}) async {
    if (query == null || filter == null || query.isEmpty) {
      await _getUnfilteredFromPage(page);
    } else {
      await _searchFromPage(
        query: query,
        filter: filter,
        page: page,
      );
    }
  }

  Future<void> refresh() async {
    _isLoading = true;

    await initUnfilteredInventory();

    _isLoading = false;
  }

  Future<void> _getUnfilteredFromPage(int page) async {
    _isLoading = true;

    state = state.copyWith(items: await DatabaseAPI.getInventoryUnfiltered(page));

    _isLoading = false;
  }

  Future<void> _searchFromPage({
    required String query,
    required InventorySearchFilter filter,
    required int page,
  }) async {
    if (query.isEmpty) {
      refresh();
      return;
    }

    state = state.copyWith(items: await DatabaseAPI.searchInventory(query: query, filter: filter, page: page));
  }
}
