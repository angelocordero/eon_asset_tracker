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
//var result = await conn.query('insert into users (name, email, age) values (?, ?, ?)', ['Bob', 'bob@bob.com', 25]);

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
        item.departmentID,
        item.personAccountable,
        item.model,
        item.description,
        item.unit,
        item.price,
        item.datePurchased?.toUtc(),
        item.dateReceived?.toUtc(),
        item.status,
        item.categoryID,
        item.remarks
      ]);
    } catch (e) {
      debugPrint(e.toString());
    }
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
