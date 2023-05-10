import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/models/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import '../models/category_model.dart';
import '../models/department_model.dart';

class InventoryNotifier extends StateNotifier<List<Item>> {
  InventoryNotifier({
    required this.conn,
    required this.departments,
    required this.categories,
  }) : super([]);

  MySqlConnection? conn;
  List<Department> departments;
  List<ItemCategory> categories;

  bool _isLoading = true;

  set loading(bool state) {
    _isLoading = state;
  }

  get isLoading => _isLoading;

  Future<void> init(int page) async {
    if (conn == null) return;

    _isLoading = true;

    state = await DatabaseAPI.getInventory(conn, departments, categories, page);

    _isLoading = false;
  }

  Future<void> refresh() async {
    if (conn == null) return;
    _isLoading = true;

    state = [];

    await Future.delayed(const Duration(milliseconds: 200));

    state = await DatabaseAPI.getInventory(conn, departments, categories, 0);

    _isLoading = false;
  }

  void search({
    required MySqlConnection? conn,
    required String query,
    required String searchBy,
  }) async {
    if (query.isEmpty) {
      refresh();
      return;
    }

    state = await DatabaseAPI.search(
      conn: conn,
      query: query,
      searchBy: searchBy,
      departments: departments,
      categories: categories,
    );
  }
}
