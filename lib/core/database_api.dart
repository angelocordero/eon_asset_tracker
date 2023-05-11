import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

class DatabaseAPI {
  static Future<int> getTotal({required MySQLConnection? conn}) async {
    if (conn == null) return 0;

    IResultSet result = await conn.execute('SELECT * FROM `assets` WHERE `is_enabled` = 1 ', {});

    return result.length;
  }

  static Future<Map<String, int>> statusData({required MySQLConnection? conn}) async {
    Map<String, int> buffer = {};

    if (conn == null) return buffer;

    IResultSet result = await conn.execute('SELECT `status`, COUNT(*) as count FROM `assets` WHERE `is_enabled` = 1 GROUP BY `status`');

    for (ResultSetRow row in result.rows) {
      buffer[row.typedColByName<String>('status').toString()] = row.typedColByName<int>('count') ?? 0;
    }

    return buffer;
  }

  static Future<List<Map<String, dynamic>>> departmentsData({required MySQLConnection? conn, required List<Department> departments}) async {
    List<Map<String, dynamic>> buffer = [];

    if (conn == null) return buffer;

    IResultSet results = await conn.execute('SELECT `department_id`, COUNT(*) as count FROM `assets` WHERE `is_enabled` = 1 GROUP BY `department_id`');

    List<ResultSetRow> rows = results.rows.toList();

    List<String> rowDepartment = rows.map((e) => e.typedColByName<String>('department_id')!).toList();

    for (int i = 0; i < departments.length; i++) {
      if (rowDepartment.contains(departments[i].departmentID)) {
        ResultSetRow row = rows.firstWhere((element) {
          return element.typedColByName<String>('department_id') == departments[i].departmentID;
        });

        buffer.add({
          'departmentName': departments[i].departmentName,
          'count': row.typedColByName<int>('count'),
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

    IResultSet results = await conn.query('SELECT `category_id`, COUNT(*) as count FROM `assets`  WHERE `is_enabled` = 1 GROUP BY `category_id`');

    List<ResultSetRow> rows = results.rows.toList();

    List<String> rowCategories = rows.map((e) => e.typedColByName<String>('category_id')!).toList();

    for (int i = 0; i < categories.length; i++) {
      if (rowCategories.contains(categories[i].categoryID)) {
        ResultSetRow row = rows.firstWhere((element) {
          return element.typedColByName<String>('category_id') == categories[i].categoryID;
        });

        buffer.add({
          'departmentName': categories[i].categoryName,
          'count': row.typedColByName<int>('count'),
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
    required MySQLConnection? conn,
    required String assetID,
  }) async {
    if (conn == null) return;

    try {
      await conn.execute(
        'UPDATE `assets` SET `is_enabled` = 0 WHERE `asset_id` = :assetID',
        {'assetID': assetID},
      );
    } catch (e) {
      return Future.error('Error in deleting item');
    }
  }

  static Future<IResultSet> _searchQuery({required MySQLConnection conn, required String searchBy, required String query}) async {
    return await conn.execute('SELECT * FROM `assets` WHERE `$searchBy` LIKE \'%$query%\' AND `is_enabled` = 1 ORDER BY `timestamp` DESC');
  }

  static Future<List<Item>> search({
    required MySQLConnection? conn,
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
      IResultSet results = await _searchQuery(
        conn: conn,
        searchBy: columnString,
        query: query,
      );

      return results.rows
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
    required MySQLConnection? conn,
    required Item item,
  }) async {
    if (conn == null) return;

    try {
      await conn.execute('''UPDATE `assets` SET   
          department_id = :departmentID,
          person_accountable = :personAccountable,
          item_name = :itemName ,
          item_description = :itemDescription,
          unit = :unit,
          price = :price,
          date_purchased = :datePurchased,
          date_received = :dateReceived,
          status = :status,
          category_id = :categoryID,
          remarks = :remarks
          WHERE `asset_id`= :assetID''', {
        'departmentID': item.department.departmentID,
        'personAccountable': item.personAccountable,
        'itemName': item.name,
        'itemDescription': item.description,
        'unit': item.unit,
        'price': item.price,
        'datePurchased': item.datePurchased?.toUtc(),
        'dateReceived': item.dateReceived.toUtc(),
        'status': item.status.name,
        'categoryID': item.category.categoryID,
        'remarks': item.remarks,
        'assetID': item.assetID,
      });
    } catch (e) {
      return Future.error('Error in editing item');
    }
  }

  static Future<void> add({
    required MySQLConnection? conn,
    required Item item,
  }) async {
    if (conn == null) return;

    try {
      await conn.execute('''INSERT INTO assets (
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
          (:assetID, departmentID, personAccountable, itemName, itemDescription, unit, price,)''', {
        'departmentID': item.department.departmentID,
        'personAccountable': item.personAccountable,
        'itemName': item.name,
        'itemDescription': item.description,
        'unit': item.unit,
        'price': item.price,
        'datePurchased': item.datePurchased?.toUtc(),
        'dateReceived': item.dateReceived.toUtc(),
        'status': item.status.name,
        'categoryID': item.category.categoryID,
        'remarks': item.remarks,
        'assetID': item.assetID,
      });
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

  static Future<List<Item>> getALl(
    MySqlConnection? conn,
    List<Department> departments,
    List<ItemCategory> categories,
  ) async {
    if (conn == null) return Future.value([]);

    var results = await conn.query('SELECT * FROM `assets` WHERE `is_enabled` = 1 ORDER BY `timestamp` DESC', []);

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
