import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql1/mysql1.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

class DatabaseAPI {
  static Future<int> getTotal({required MySqlConnection? conn}) async {
    if (conn == null) return 0;

    Results results = await conn.query('SELECT * FROM `assets` WHERE `is_enabled` = 1 ', []);

    return results.length;
  }

  static Future<Map<String, int>> statusData({required MySqlConnection? conn}) async {
    Map<String, int> buffer = {};

    if (conn == null) return buffer;

    Results results = await conn.query('SELECT `status`, COUNT(*) as count FROM `assets` WHERE `is_enabled` = 1 GROUP BY `status`');

    for (ResultRow row in results) {
      buffer[row[0] as String] = row[1] ?? 0;
    }

    return buffer;
  }

  static Future<List<Map<String, dynamic>>> departmentsData({required MySqlConnection? conn, required List<Department> departments}) async {
    List<Map<String, dynamic>> buffer = [];

    if (conn == null) return buffer;

    Results results = await conn.query('SELECT `department_id`, COUNT(*) as count FROM `assets` WHERE `is_enabled` = 1 GROUP BY `department_id`');

    List<ResultRow> rows = results.toList();

    List<String> rowDepartment = rows.map((e) => e['department_id'] as String).toList();

    for (int i = 0; i < departments.length; i++) {
      if (rowDepartment.contains(departments[i].departmentID)) {
        ResultRow row = rows.firstWhere((element) {
          return element['department_id'] == departments[i].departmentID;
        });

        buffer.add({
          'departmentName': departments[i].departmentName,
          'count': row['count'],
          'index': i,
        });
      } else {
        buffer.add({
          'departmentName': departments[i].departmentName,
          'count': 0,
          'index': i,
        });
      }
    }

    return buffer;
  }

  static Future<List<Map<String, dynamic>>> categoriesData({required MySqlConnection? conn, required List<ItemCategory> categories}) async {
    List<Map<String, dynamic>> buffer = [];

    if (conn == null) return buffer;

    Results results = await conn.query('SELECT `category_id`, COUNT(*) as count FROM `assets`  WHERE `is_enabled` = 1 GROUP BY `category_id`');

    List<ResultRow> rows = results.toList();

    List<String> rowCategories = rows.map((e) => e['category_id'] as String).toList();

    for (int i = 0; i < categories.length; i++) {
      if (rowCategories.contains(categories[i].categoryID)) {
        ResultRow row = rows.firstWhere((element) {
          return element['category_id'] == categories[i].categoryID;
        });

        buffer.add({
          'departmentName': categories[i].categoryName,
          'count': row['count'],
          'index': i,
        });
      } else {
        buffer.add({
          'departmentName': categories[i].categoryName,
          'count': 0,
          'index': i,
        });
      }
    }

    return buffer;
  }

  static Future<void> delete({
    required MySqlConnection? conn,
    required String assetID,
  }) async {
    if (conn == null) return;

    try {
      await conn.query('UPDATE `assets` SET `is_enabled` = 0 WHERE `asset_id` = ?', [assetID]);
    } catch (e) {
      return Future.error('Error in deleting item');
    }
  }

  static Future<Results> _searchQuery({required MySqlConnection conn, required String searchBy, required String query}) async {
    return await conn.query('SELECT * FROM `assets` WHERE `$searchBy` LIKE \'%$query%\' AND `is_enabled` = 1 ORDER BY `timestamp` DESC', []);
  }

  static Future<List<Item>> search({
    required MySqlConnection? conn,
    required String query,
    required String searchBy,
    required List<Department> departments,
    required List<ItemCategory> categories,
  }) async {
    if (conn == null) return Future.value([]);

    String columnString = '';

    try {
      switch (searchBy) {
        case 'Asset ID':
          columnString = 'asset_id';
          break;

        case 'Item Name':
          columnString = 'item_name';
          break;

        case 'Person Accountable':
          columnString = 'person_accountable';
          break;

        case 'Unit':
          columnString = 'unit';
          break;

        case 'Item Description':
          columnString = 'item_description';
          break;

        case 'Remarks':
          columnString = 'remarks';
          break;

        default:
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(e.toString());
    }

    try {
      Results results = await _searchQuery(
        conn: conn,
        searchBy: columnString,
        query: query,
      );

      return results
          .map<Item>(
            (row) => Item.fromDatabase(
              row: row,
              departments: departments,
              categories: categories,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError(e.toString());

      return [];
    }
  }

  static Future<void> update({
    required MySqlConnection conn,
    required Item item,
  }) async {
    try {
      await conn.query('''UPDATE `assets` SET   
          department_id = ?,
          person_accountable = ?,
          item_name = ? ,
          item_description = ?,
          unit = ?,
          price = ? ,
          date_purchased = ?,
          date_received = ?,
          status = ?,
          category_id = ?,
          remarks = ?
          WHERE `asset_id`=?''', [
        item.department.departmentID,
        item.personAccountable,
        item.name,
        item.description,
        item.unit,
        item.price,
        item.datePurchased?.toUtc(),
        item.dateReceived.toUtc(),
        item.status.name,
        item.category.categoryID,
        item.remarks,
        item.assetID,
      ]);
    } catch (e) {
      return Future.error('Error in editing item');
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
          item_name,
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
        item.department.departmentID,
        item.personAccountable,
        item.name,
        item.description,
        item.unit,
        item.price,
        item.datePurchased?.toUtc(),
        item.dateReceived.toUtc(),
        item.status.name,
        item.category.categoryID,
        item.remarks
      ]);
    } catch (e) {
      return Future.error('Error in adding item');
    }
  }

  static Future<List<Item>> getInventory(
    MySqlConnection? conn,
    List<Department> departments,
    List<ItemCategory> categories,
    int page,
  ) async {
    if (conn == null) return Future.value([]);

    int offset = (itemsPerPage * page);

    var results = await conn.query('SELECT * FROM `assets` WHERE `is_enabled` = 1 ORDER BY `timestamp` DESC LIMIT $itemsPerPage OFFSET $offset', []);

    return results.map<Item>((row) {
      return Item.fromDatabase(
        row: row,
        categories: categories,
        departments: departments,
      );
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
