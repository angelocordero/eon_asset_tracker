import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

class DatabaseAPI {
  static Future<void> add({
    required MySqlConnection conn,
    required Item item,
  }) async {
    try {
      await conn.query('''INSERT INTO assets (
          asset_id, 
          department_id,
          person_accountable,
          item_model,
          item_description,
          unit,
          price,
          date_purchased,
          date_received,
          status,
          category_id,
          remarks)
          VALUES
          (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''', [
        item.assetID,
        item.department,
        item.personAccountable,
        item.model,
        item.description,
        item.unit,
        item.price,
        item.datePurchased?.toUtc(),
        item.dateReceived?.toUtc(),
        item.status,
        item.category,
        item.remarks
      ]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<Item>> getInventory(MySqlConnection conn,
      List<Department> departments, List<ItemCategory> categories) async {
    var results = await conn.query('SELECT * FROM `assets` WHERE 1', []);

    return results.map<Item>((row) {
      String department = departments
          .firstWhere((element) => element.departmentID == row[1])
          .departmentName;

      String category = categories
          .firstWhere((element) => element.categoryID == row[10])
          .categoryName;
      return Item(
          assetID: row[0],
          department: department,
          personAccountable: row[2],
          model: row[3],
          description: row[4],
          unit: row[5],
          price: row[6],
          datePurchased: (row[7] as DateTime).toLocal(),
          dateReceived: (row[8] as DateTime).toLocal(),
          status: row[9],
          category: category,
          remarks: row[11]);
    }).toList();
  }

  static Future<List<Department>> getDepartments(MySqlConnection conn) async {
    var results = await conn.query('SELECT * FROM `departments` WHERE 1', []);

    return results.map((row) {
      return Department(
        departmentID: row[0],
        departmentName: row[1],
        isEnabled: row[2] == 1 ? true : false,
      );
    }).toList();
  }

  static Future<List<ItemCategory>> getCategories(MySqlConnection conn) async {
    var results = await conn.query('SELECT * FROM `categories` WHERE 1', []);

    return results.map((row) {
      return ItemCategory(
        categoryID: row[0],
        categoryName: row[1],
        isEnabled: row[2] == 1 ? true : false,
      );
    }).toList();
  }
}
