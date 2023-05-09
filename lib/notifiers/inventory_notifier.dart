import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/models/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import '../models/category_model.dart';
import '../models/department_model.dart';

class InventoryNotifier extends StateNotifier<List<Item>> {
  InventoryNotifier(this.ref) : super([]);

  StateNotifierProviderRef<InventoryNotifier, List<Item>> ref;

  late List<Department> departments;
  late List<ItemCategory> categories;

  Future<void> init() async {
    MySqlConnection? conn = ref.read(sqlConnProvider);

    departments = await ref.read(departmentsProvider);
    categories = await ref.read(categoriesProvider);
    if (conn == null) return;

    state = await DatabaseAPI.getInventory(conn, departments, categories);
  }

  Future<void> refresh() async {
    state = [];

    await Future.delayed(const Duration(milliseconds: 300));
    await init();
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
