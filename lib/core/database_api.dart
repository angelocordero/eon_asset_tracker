import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:eon_asset_tracker/models/dashboard_model.dart';
import 'package:eon_asset_tracker/models/department_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';
import '../notifiers/dashboard_notifier.dart';

class DatabaseAPI {
  static Future<DashboardData> initDashboard(StateNotifierProviderRef<DashboardNotifier, DashboardData> ref) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();
      return DashboardData(
        totalItems: await getTotal(conn),
        statusDashboardData: await _getTotalStatusCount(conn),
        categoriesDashbordData: await _getCategoriesCount(conn: conn, categories: ref.read(categoriesProvider)),
        departmentsDashboardData: await _getDepartmentsCount(conn: conn, departments: ref.read(departmentsProvider)),
      );
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return DashboardData.empty();
    } finally {
      await conn?.close();
    }
  }

  static Future<void> delete(String assetID) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();
      await conn.execute(
        'UPDATE `assets` SET `is_enabled` = 0 WHERE `asset_id` = :assetID',
        {'assetID': assetID},
      );
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    } finally {
      await conn?.close();
    }
  }

  static Future<int> getSearchResultTotalCount({
    required String query,
    required String searchBy,
    required List<Department> departments,
    required List<ItemCategory> categories,
  }) async {
    MySQLConnection? conn;

    String? columnString;

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

      case 'Status':
        columnString = 'status';
        break;

      case 'Department':
        columnString = 'department_id';
        break;

      case 'Category':
        columnString = 'category_id';
        break;

      default:
        columnString = null;
        break;
    }

    try {
      conn = await createSqlConn();

      if (columnString == null) {
        return Future.error('No column found');
      }

      await conn.connect();

      IResultSet results = await _searchQueryResultTotal(
        conn: conn,
        searchBy: columnString,
        query: query,
      );

      // ignore: sdk_version_since
      return results.rows.firstOrNull?.typedColByName<int>('count') ?? 0;
    } catch (e, st) {
      showErrorAndStacktrace(e, st);

      return 0;
    } finally {
      await conn?.close();
    }
  }

  static Future<List<Item>> search({
    required String query,
    required String searchBy,
    required page,
    required List<Department> departments,
    required List<ItemCategory> categories,
  }) async {
    MySQLConnection? conn;

    String? columnString;

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

      case 'Status':
        columnString = 'status';
        break;

      case 'Department':
        columnString = 'department_id';
        break;

      case 'Category':
        columnString = 'category_id';
        break;

      default:
        columnString = null;
        break;
    }

    try {
      conn = await createSqlConn();

      if (columnString == null) {
        return Future.error('No column found');
      }

      await conn.connect();

      IResultSet results = await _searchQuery(
        conn: conn,
        page: page,
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
    } catch (e, st) {
      showErrorAndStacktrace(e, st);

      return [];
    } finally {
      await conn?.close();
    }
  }

  static Future<void> update(Item item) async {
    MySQLConnection? conn;

    try {
      DateTime dateReceived = item.dateReceived;
      DateTime? datePurchased = item.datePurchased;

      conn = await createSqlConn();

      await conn.connect();

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
        'datePurchased': datePurchased == null ? null : '${datePurchased.year}-${datePurchased.month}-${datePurchased.day}',
        'dateReceived': '${dateReceived.year}-${dateReceived.month}-${dateReceived.day}',
        'status': item.status.name,
        'categoryID': item.category.categoryID,
        'remarks': item.remarks,
        'assetID': item.assetID,
      });
    } catch (e, st) {
      return Future.error(e, st);
    } finally {
      await conn?.close();
    }
  }

  static Future<void> add({
    required Item item,
  }) async {
    MySQLConnection? conn;

    try {
      DateTime dateReceived = item.dateReceived;
      DateTime? datePurchased = item.datePurchased;

      conn = await createSqlConn();

      await conn.connect();

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
          (:assetID, :departmentID, :personAccountable, :itemName, :itemDescription, :unit, :price,
          
            :datePurchased, :dateReceived, :status, :categoryID, :remarks
          )''', {
        'departmentID': item.department.departmentID,
        'personAccountable': item.personAccountable,
        'itemName': item.name,
        'itemDescription': item.description,
        'unit': item.unit,
        'price': item.price,
        'datePurchased': datePurchased == null ? null : '${datePurchased.year}-${datePurchased.month}-${datePurchased.day}',
        'dateReceived': '${dateReceived.year}-${dateReceived.month}-${dateReceived.day}',
        'status': item.status.name,
        'categoryID': item.category.categoryID,
        'remarks': item.remarks,
        'assetID': item.assetID,
      });
    } catch (e, st) {
      return Future.error(e, st);
    } finally {
      await conn?.close();
    }
  }

  static Future<List<Item>> getInventory(
    List<Department> departments,
    List<ItemCategory> categories,
    int page,
  ) async {
    MySQLConnection? conn;

    try {
      int offset = (itemsPerPage * page);

      conn = await createSqlConn();

      await conn.connect();

      var results = await conn.execute(
        'SELECT * FROM `assets` WHERE `is_enabled` = 1 ORDER BY `timestamp` DESC LIMIT $itemsPerPage OFFSET $offset',
      );

      return results.rows.map<Item>((row) {
        return Item.fromDatabase(
          row: row,
          categories: categories,
          departments: departments,
        );
      }).toList();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return Future.value([]);
    } finally {
      await conn?.close();
    }
  }

  static Future<List<Item>> getAll(
    List<Department> departments,
    List<ItemCategory> categories,
  ) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      var results = await conn.execute('SELECT * FROM `assets` WHERE `is_enabled` = 1 ORDER BY `timestamp` DESC');

      return results.rows.map<Item>((row) {
        return Item.fromDatabase(
          row: row,
          categories: categories,
          departments: departments,
        );
      }).toList();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return Future.value([]);
    } finally {
      await conn?.close();
    }
  }

  static Future<User?> authenticateUser(String username, String passwordHash, WidgetRef ref) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await Future.delayed(const Duration(milliseconds: 200));

      await conn.connect();

      IResultSet results = await conn.execute(
        'SELECT * FROM `users` WHERE `username`= :username and `password_hash`= :password',
        {'username': username, 'password': passwordHash},
      );

      if (results.rows.isEmpty) return Future.error('No user found');

      ResultSetRow row = results.rows.first;

      ref.read(departmentsProvider.notifier).state = await _getDepartments(conn);
      ref.read(categoriesProvider.notifier).state = await _getCategories(conn);

      return User(
        userID: row.typedColByName<String>('user_id')!,
        username: row.typedColByName<String>('username')!,
        isAdmin: row.typedColByName<int>('admin')! == 1 ? true : false,
      );
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      await conn?.close();
    }
  }

  static Future<int> getTotal(MySQLConnection conn) async {
    try {
      IResultSet result = await conn.execute('SELECT * FROM `assets` WHERE `is_enabled` = 1 ', {});

      return result.numOfRows;
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return Future.value(0);
    }
  }

  static Future<Map<String, int>> _getTotalStatusCount(MySQLConnection conn) async {
    try {
      Map<String, int> buffer = {};

      IResultSet result = await conn.execute('SELECT `status`, COUNT(*) as count FROM `assets` WHERE `is_enabled` = 1 GROUP BY `status`');

      for (ResultSetRow row in result.rows) {
        buffer[row.typedColByName<String>('status').toString()] = row.typedColByName<int>('count') ?? 0;
      }

      return buffer;
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  static Future<List<Map<String, dynamic>>> _getDepartmentsCount({required MySQLConnection conn, required List<Department> departments}) async {
    try {
      List<Map<String, dynamic>> buffer = [];

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
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  static Future<List<Map<String, dynamic>>> _getCategoriesCount({required MySQLConnection conn, required List<ItemCategory> categories}) async {
    try {
      List<Map<String, dynamic>> buffer = [];

      IResultSet results = await conn.execute('SELECT `category_id`, COUNT(*) as count FROM `assets`  WHERE `is_enabled` = 1 GROUP BY `category_id`');

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
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  static Future<IResultSet> _searchQuery({
    required MySQLConnection conn,
    required int page,
    required String searchBy,
    required String query,
  }) async {
    int offset = (itemsPerPage * page);

    try {
      return await conn.execute('SELECT * FROM `assets` WHERE `$searchBy` LIKE \'%$query%\' AND `is_enabled` = 1 ORDER BY `timestamp` DESC LIMIT $itemsPerPage OFFSET $offset');
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  static Future<IResultSet> _searchQueryResultTotal({required MySQLConnection conn, required String searchBy, required String query}) async {
    try {
      return await conn.execute('SELECT COUNT(*) as count FROM `assets` WHERE `$searchBy` LIKE \'%$query%\' AND `is_enabled` = 1');
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  static Future<List<Department>> _getDepartments(MySQLConnection conn) async {
    try {
      var results = await conn.execute('SELECT * FROM `departments` WHERE 1');

      return results.rows.map((row) {
        return Department(
          departmentID: row.typedColByName<String>('department_id')!,
          departmentName: row.typedColByName<String>('department_name')!,
          isEnabled: row.typedColByName<int>('is_enabled')! == 1 ? true : false,
        );
      }).toList();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  static Future<List<ItemCategory>> _getCategories(MySQLConnection conn) async {
    try {
      var results = await conn.execute('SELECT * FROM `categories` WHERE 1');

      return results.rows.map((row) {
        return ItemCategory(
          categoryID: row.typedColByName<String>('category_id')!,
          categoryName: row.typedColByName<String>('category_name')!,
          isEnabled: row.typedColByName<int>('is_enabled')! == 1 ? true : false,
        );
      }).toList();
    } catch (e, st) {
      return Future.error(e, st);
    }
  }
}
