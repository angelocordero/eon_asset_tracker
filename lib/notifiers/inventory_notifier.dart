import 'package:eon_asset_tracker/core/database_api.dart';
import 'package:eon_asset_tracker/models/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import '../models/category_model.dart';
import '../models/department_model.dart';

class InventoryNotifier extends StateNotifier<List<Item>> {
  InventoryNotifier() : super([]);

  void init(MySqlConnection conn, List<Department> departments,
      List<ItemCategory> categories) async {
    state = await DatabaseAPI.getInventory(conn, departments, categories);
  }
}
