import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

class DatabaseAPI {
  static Future<void> delete({
    required MySqlConnection? conn,
    required String assetID,
  }) async {
    if (conn == null) return;

    try {
      await conn.query(
          'UPDATE `assets` SET `is_enabled` = 0 WHERE `asset_id` = ?',
          [assetID]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<Item>> search({
    required MySqlConnection? conn,
    required String query,
    required String searchBy,
  }) async {
    if (conn == null) return Future.value([]);

    List<Item> buffer = [];

//SELECT * FROM employee_name_details WHERE emp_lastName LIKE '%ill%' ;

// / SELECT * FROM employee_name_details WHERE emp_firstName LIKE 'R%' ;

    try {
      switch (searchBy) {
        case 'Asset ID':
          var results = await conn.query(
              'SELECT *FROM `assets` WHERE `asset_id` LIKE \'%$query%\'', []);

          buffer = results.map<Item>((row) => Item.fromResultRow(row)).toList();
          break;
        case 'Item Model / Serial Number':
          var results = await conn.query(
              'SELECT *FROM `assets` WHERE `item_model` LIKE \'%$query%\'', []);

          buffer = results.map<Item>((row) => Item.fromResultRow(row)).toList();
          break;

        case 'Person Accountable':
          var results = await conn.query(
              'SELECT *FROM `assets` WHERE `person_accountable` LIKE \'%$query%\'',
              []);

          buffer = results.map<Item>((row) => Item.fromResultRow(row)).toList();
          break;
        case 'Unit':
          var results = await conn.query(
              'SELECT *FROM `assets` WHERE `unit` LIKE \'%$query%\'', []);

          buffer = results.map<Item>((row) => Item.fromResultRow(row)).toList();
          break;
        case 'Item Description':
          var results = await conn.query(
              'SELECT *FROM `assets` WHERE `item_description` LIKE \'%$query%\'',
              []);

          buffer = results.map<Item>((row) => Item.fromResultRow(row)).toList();
          break;

        case 'Remarks':
          var results = await conn.query(
              'SELECT *FROM `assets` WHERE `remarks` LIKE \'%$query%\'', []);

          buffer = results.map<Item>((row) => Item.fromResultRow(row)).toList();
          break;

        default:
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return buffer;
  }

  static Future<void> update({
    required MySqlConnection conn,
    required Item item,
  }) async {
    try {
      await conn.query('''UPDATE `assets` SET   
          department_id = ?,
          person_accountable = ?,
          item_model = ? ,
          item_description = ?,
          unit = ?,
          price = ? ,
          date_purchased = ?,
          date_received = ?,
          status = ?,
          category_id = ?,
          remarks = ?
          WHERE `asset_id`=?''', [
        item.departmentID,
        item.personAccountable,
        item.model,
        item.description,
        item.unit,
        item.price,
        item.datePurchased?.toUtc(),
        item.dateReceived.toUtc(),
        item.status.name,
        item.categoryID,
        item.remarks,
        item.assetID,
      ]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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
        item.departmentID,
        item.personAccountable,
        item.model,
        item.description,
        item.unit,
        item.price,
        item.datePurchased?.toUtc(),
        item.dateReceived.toUtc(),
        item.status.name,
        item.categoryID,
        item.remarks
      ]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<List<Item>> getInventory(MySqlConnection? conn,
      List<Department> departments, List<ItemCategory> categories) async {
    if (conn == null) return Future.value([]);

    var results =
        await conn.query('SELECT * FROM `assets` WHERE `is_enabled` = 1', []);

    return results.map<Item>((row) {
      return Item.fromResultRow(row);
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
