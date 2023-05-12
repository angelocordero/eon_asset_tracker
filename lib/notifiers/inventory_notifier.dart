import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/models/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/category_model.dart';
import '../models/department_model.dart';

class InventoryNotifier extends StateNotifier<List<Item>> {
  InventoryNotifier({
    required this.ref,
    required this.departments,
    required this.categories,
  }) : super([]);

  StateNotifierProviderRef<InventoryNotifier, List<Item>> ref;

  List<Department> departments;
  List<ItemCategory> categories;

  bool _isLoading = true;

  set loading(bool state) {
    _isLoading = state;
  }

  get isLoading => _isLoading;

  Future<void> getItems(int page) async {
    String query = await ref.read(searchQueryProvider);

    if (query.isEmpty) {
      await _init(page);
    } else {
      await _search(
        query: query,
        searchBy: ref.read(searchFilterProvider),
        page: page,
      );
    }
  }

  Future<void> _init(int page) async {
    _isLoading = true;

    MySQLConnection conn = await createSqlConn();

    await conn.connect();

    ref.read(queryResultItemCount.notifier).state = await DatabaseAPI.getTotal(conn);

    await conn.close();

    state = await DatabaseAPI.getInventory(departments, categories, page);

    _isLoading = false;
  }

  Future<void> refresh() async {
    _isLoading = true;

    state = [];

    ref.read(searchQueryProvider.notifier).state = '';

    await Future.delayed(const Duration(milliseconds: 200));

    await getItems(0);

    _isLoading = false;
  }

  Future<void> _search({
    required String query,
    required String searchBy,
    required int page,
  }) async {
    if (query.isEmpty) {
      refresh();

      return;
    }
    ref.read(queryResultItemCount.notifier).state = await DatabaseAPI.getSearchResultTotalCount(
      query: query,
      searchBy: searchBy,
      departments: departments,
      categories: categories,
    );

    state = await DatabaseAPI.search(
      query: query,
      page: page,
      searchBy: searchBy,
      departments: departments,
      categories: categories,
    );
  }
}
