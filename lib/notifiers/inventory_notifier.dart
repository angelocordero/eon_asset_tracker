// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client/mysql_client.dart';

// Project imports:
import '../core/constants.dart';
import '../core/database_api.dart';
import '../core/utils.dart';
import '../models/inventory_model.dart';

class InventoryNotifier extends StateNotifier<Inventory> {
  InventoryNotifier(this.itemsPerPage) : super(Inventory.empty()) {
    refresh();
  }

  bool _isLoading = true;

  int itemsPerPage;

  set loading(bool state) {
    _isLoading = state;
  }

  get isLoading => _isLoading;

  void sortTable(TableSort tableSort) {
    Columns? column = tableSort.$1;
    Sort? sort = tableSort.$2;

    switch (column) {
      case Columns.assetID:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => a.assetID.compareTo(b.assetID));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => b.assetID.compareTo(a.assetID));
        }
        break;
      case Columns.itemName:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => a.name.compareTo(b.name));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => b.name.compareTo(a.name));
        }

      case Columns.departmentName:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => a.department.departmentName.compareTo(b.department.departmentName));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => b.department.departmentName.compareTo(a.department.departmentName));
        }

      case Columns.personAccountable:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => compareStrings(a.personAccountable, b.personAccountable, descending: false));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => compareStrings(a.personAccountable, b.personAccountable, descending: true));
        }

      case Columns.category:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => a.category.categoryName.compareTo(b.category.categoryName));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => b.category.categoryName.compareTo(a.category.categoryName));
        }

      case Columns.status:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => a.status.name.compareTo(b.status.name));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => b.status.name.compareTo(a.status.name));
        }

      case Columns.unit:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => compareStrings(a.unit, b.unit, descending: false));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => compareStrings(a.unit, b.unit, descending: true));
        }

      case Columns.price:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => compareValues(a.price, b.price, descending: false));
        } else {
          state.items.sort((a, b) => compareValues(a.price, b.price, descending: true));
        }

      case Columns.datePurchased:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => compareDates(a.datePurchased, b.datePurchased, descending: false));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => compareDates(a.datePurchased, b.datePurchased, descending: true));
        }

      case Columns.dateReceived:
        if (sort == Sort.ascending) {
          state.items.sort((a, b) => a.dateReceived.compareTo(b.dateReceived));
        } else if (sort == Sort.descending) {
          state.items.sort((a, b) => b.dateReceived.compareTo(a.dateReceived));
        }
      default:
    }

    state = state.copyWith(items: state.items);
  }

  Future<void> initUnfilteredInventory() async {
    _isLoading = true;

    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      state = state.copyWith(
        items: await DatabaseAPI.getInventoryUnfiltered(page: 0, itemsPerPage: itemsPerPage),
        count: await DatabaseAPI.getTotalInventoryCount(conn),
      );
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
      items: await DatabaseAPI.searchInventory(query: query, filter: filter, page: 0, itemsPerPage: itemsPerPage),
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

    state = state.copyWith(items: await DatabaseAPI.getInventoryUnfiltered(page: page, itemsPerPage: itemsPerPage));

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

    state = state.copyWith(items: await DatabaseAPI.searchInventory(query: query, filter: filter, page: page, itemsPerPage: itemsPerPage));
  }
}
