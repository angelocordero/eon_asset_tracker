// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';
import 'constants.dart';
import 'utils.dart';

class DatabaseAPI {
  //! ///////////////////////////////////////////////////
  //! USERS
  //! ///////////////////////////////////////////////////

  static Future<void> editUser(User user) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      await conn.execute('''UPDATE `users` SET `username` = :username, `department_id` = :departmentID, `admin` = :isAdmin
       WHERE `user_id` = :userID AND `is_enabled` = 1 ''', {
        'username': user.username,
        'departmentID': user.department?.departmentID,
        'isAdmin': user.isAdmin ? 1 : 0,
        'userID': user.userID,
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> deleteUser(User user) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      await conn.execute('''UPDATE `users` SET `is_enabled` = 0
       WHERE `user_id` = :userID ''', {
        'userID': user.userID,
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> resetPassword(User user, String newPassword) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      await conn.execute('''UPDATE `users` SET `password_hash` = :hash WHERE `is_enabled` = 1
       AND `user_id` = :userID ''', {
        'hash': hashPassword(newPassword),
        'userID': user.userID,
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> addUser(User user, String password) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      await conn.execute('''INSERT INTO `users` (user_id, username, admin, department_id ,password_hash) VALUES
          (:userID, :username, :isAdmin, :departmentID, :passwordHash)''', {
        'userID': user.userID,
        'username': user.username,
        'isAdmin': user.isAdmin ? 1 : 0,
        'departmentID': user.department?.departmentID,
        'passwordHash': hashPassword(password),
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<List<User>> getUsers() async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      IResultSet results = await conn.execute('''
        SELECT u.*, d.department_name FROM `users` AS u
        JOIN `departments` as d ON u.department_id = d.department_id
        WHERE u.is_enabled = 1 ORDER BY `admin` DESC, `username` ASC''');

      return results.rows.map((row) => User.fromDatabase(row)).toList();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return [];
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<bool> getAdminPassword(String password) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      IResultSet results = await conn.execute('''
                                              SELECT `password_hash`
                                              FROM `users`
                                              WHERE `admin` = 1
                                              UNION
                                              SELECT `hash` AS `password_hash`
                                              FROM `master`;
                                              ''');

      List<String?> list = results.rows.map((e) => e.typedColAt<String>(0)).toList();

      if (list.contains(hashPassword(password))) return true;
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }

    return false;
  }

  static Future<bool> getMasterPassword(String password) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      IResultSet results = await conn.execute('SELECT * FROM `master` WHERE 1;');

      List<String?> list = results.rows.map((e) => e.typedColAt<String>(0)).toList();

      if (list.contains(hashPassword(password))) return true;
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }

    return false;
  }

  static Future<User?> authenticateUser(WidgetRef ref, String username, String passwordHash) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await Future.delayed(const Duration(milliseconds: 200));

      await conn.connect();

      IResultSet results = await conn.execute('''
      SELECT u.*, d.department_name FROM `users` AS u
      JOIN `departments` AS d ON u.department_id = d.department_id
      WHERE u.is_enabled = 1 AND d.is_enabled = 1 
      AND u.username = :username AND u.password_hash = :hash''', {
        'username': username,
        'hash': passwordHash,
      });

      if (results.rows.isEmpty) return await Future.error('No User Found');

      ResultSetRow row = results.rows.first;

      return User.fromDatabase(row);
    } catch (e) {
      return await Future.error(e.toString());
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  //! ///////////////////////////////////////////////////
  //! INVENTORY
  //! ///////////////////////////////////////////////////

  static Future<int> getTotalInventoryCount(MySQLConnection conn) async {
    try {
      IResultSet result = await conn.execute('SELECT * FROM `assets` WHERE `is_enabled` = 1 ', {});

      return result.numOfRows;
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return Future.value(0);
    }
  }

  static Future<List<Item>> getItemsForReport({
    required String query,
    required InventorySearchFilter filter,
  }) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      IResultSet results;

      if (query.trim().isEmpty) {
        results = await _getAllUnfiltered(conn);
      } else {
        results = await _getAllFiltered(conn: conn, filter: filter, query: query);
      }

      return results.rows.map<Item>((row) {
        return Item.fromDatabase(
          row: row,
        );
      }).toList();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return Future.value([]);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<IResultSet> _getAllUnfiltered(MySQLConnection conn) async {
    return await conn.execute('''
              SELECT a.*, c.category_name, d.department_name  FROM `assets` AS a
              JOIN `categories` AS c ON a.category_id = c.category_id
              JOIN `departments` AS d ON a.department_id = d.department_id
              WHERE  c.is_enabled = 1
              AND d.is_enabled = 1 
              AND a.is_enabled = 1
              ORDER BY `timestamp` DESC, `item_name` ASC''');
  }

  static Future<IResultSet> _getAllFiltered({
    required MySQLConnection conn,
    required InventorySearchFilter filter,
    required String query,
  }) async {
    String? columnString = inventoryFilterEnumToDatabaseString(filter);

    return await conn.execute('''
              SELECT a.*, c.category_name, d.department_name  FROM `assets` AS a
              JOIN `categories` AS c ON a.category_id = c.category_id
              JOIN `departments` AS d ON a.department_id = d.department_id
              WHERE  c.is_enabled = 1
              AND d.is_enabled = 1 
              AND a.is_enabled = 1 AND a.$columnString LIKE '%$query%'
              ORDER BY `timestamp` DESC, `item_name` ASC''');
  }

  static Future<List<Item>> searchInventory({
    required dynamic query,
    required InventorySearchFilter filter,
    required page,
    required int itemsPerPage,
  }) async {
    MySQLConnection? conn;

    String? columnString = inventoryFilterEnumToDatabaseString(filter);

    try {
      conn = await createSqlConn();

      await conn.connect();

      IResultSet results;

      if (filter == InventorySearchFilter.datePurchased || filter == InventorySearchFilter.dateReceived) {
        results = await _dateRangeSearch(conn: conn, columnString: columnString, range: query, itemsPerPage: itemsPerPage, page: page);
      } else {
        results = await _searchQuery(conn: conn, page: page, filter: filter, query: query, itemsPerPage: itemsPerPage);
      }

      return results.rows
          .map<Item>(
            (row) => Item.fromDatabase(
              row: row,
            ),
          )
          .toList();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);

      return [];
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> updateItem(Item item) async {
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
        'datePurchased': datePurchased == null ? null : dateTimeToSQLString(datePurchased),
        'dateReceived': dateTimeToSQLString(dateReceived),
        'status': item.status.name,
        'categoryID': item.category.categoryID,
        'remarks': item.remarks,
        'assetID': item.assetID,
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> addItem({
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
        'datePurchased': datePurchased == null ? null : dateTimeToSQLString(datePurchased),
        'dateReceived': dateTimeToSQLString(dateReceived),
        'status': item.status.name,
        'categoryID': item.category.categoryID,
        'remarks': item.remarks,
        'assetID': item.assetID,
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<IResultSet> _searchQuery({
    required MySQLConnection conn,
    required int page,
    required int itemsPerPage,
    required InventorySearchFilter filter,
    required String query,
  }) async {
    int offset = (itemsPerPage * page);

    String? columnString = inventoryFilterEnumToDatabaseString(filter);

    try {
      return await conn.execute('''
              SELECT a.*, c.category_name, d.department_name  FROM `assets` AS a
              JOIN `categories` AS c ON a.category_id = c.category_id
              JOIN `departments` AS d ON a.department_id = d.department_id
              WHERE  c.is_enabled = 1
              AND d.is_enabled = 1 
              AND a.is_enabled = 1 AND a.$columnString LIKE '%$query%'
              ORDER BY `timestamp` DESC, `item_name` ASC
              LIMIT $itemsPerPage OFFSET $offset''');
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }

  static Future<IResultSet> _dateRangeSearchTotal({
    required MySQLConnection conn,
    required String columnString,
    required DateTimeRange range,
  }) async {
    try {
      return await conn.execute(
          'SELECT COUNT(*) as count FROM `assets` WHERE `$columnString` BETWEEN \'${dateTimeToSQLString(range.start)}\' AND \'${dateTimeToSQLString(range.end)}\' AND `is_enabled` = 1');
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }

  static Future<IResultSet> _dateRangeSearch({
    required MySQLConnection conn,
    required String columnString,
    required DateTimeRange range,
    required int itemsPerPage,
    required int page,
  }) async {
    int offset = (itemsPerPage * page);

    try {
      return await conn.execute('''
              SELECT a.*, c.category_name, d.department_name  FROM `assets` AS a
              JOIN `categories` AS c ON a.category_id = c.category_id
              JOIN `departments` AS d ON a.department_id = d.department_id
              WHERE a.is_enabled = 1
              AND c.is_enabled = 1
              AND d.is_enabled = 1
              AND `$columnString` BETWEEN '${dateTimeToSQLString(range.start)}' AND '${dateTimeToSQLString(range.end)}'
              ORDER BY $columnString DESC, `item_name` ASC
              LIMIT $itemsPerPage OFFSET $offset''');
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }

  static Future<IResultSet> _searchQueryResultTotal({required MySQLConnection conn, required String searchBy, required String query}) async {
    try {
      return await conn.execute('SELECT COUNT(*) as count FROM `assets` WHERE `$searchBy` LIKE \'%$query%\' AND `is_enabled` = 1');
    } catch (e, st) {
      return await Future.error(e, st);
    }
  }

  static Future<List<Item>> getInventoryUnfiltered({
    required int page,
    required int itemsPerPage,
  }) async {
    MySQLConnection? conn;

    try {
      int offset = (itemsPerPage * page);

      conn = await createSqlConn();

      await conn.connect();

      var results = await conn.execute('''
              SELECT a.*, c.category_name, d.department_name  FROM `assets` AS a
              JOIN `categories` AS c ON a.category_id = c.category_id
              JOIN `departments` AS d ON a.department_id = d.department_id
              WHERE a.is_enabled = 1
              AND c.is_enabled = 1
              AND d.is_enabled = 1
              ORDER BY `timestamp` DESC, `item_name` ASC
              LIMIT $itemsPerPage OFFSET $offset''');

      return results.rows.map<Item>((row) {
        return Item.fromDatabase(
          row: row,
        );
      }).toList();
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
      return Future.value([]);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> deleteItem(String assetID) async {
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
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<int> getSearchResultTotalCount({
    required dynamic query,
    required InventorySearchFilter filter,
  }) async {
    MySQLConnection? conn;

    String? columnString = inventoryFilterEnumToDatabaseString(filter);

    try {
      conn = await createSqlConn();

      await conn.connect();

      IResultSet results;

      if (filter == InventorySearchFilter.datePurchased || filter == InventorySearchFilter.dateReceived) {
        results = await _dateRangeSearchTotal(conn: conn, columnString: columnString, range: query);
      } else {
        results = await _searchQueryResultTotal(
          conn: conn,
          searchBy: columnString,
          query: query,
        );
      }

      // ignore: sdk_version_since
      return results.rows.firstOrNull?.typedColByName<int>('count') ?? 0;
    } catch (e, st) {
      showErrorAndStacktrace(e, st);

      return 0;
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  //! ///////////////////////////////////////////////////
  //! DEPARTMENT AND CATEGORY
  //! ///////////////////////////////////////////////////

  static Future<Map<String, int>> getStatusCount() async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      IResultSet results = await conn.execute(
        'SELECT status, COUNT(status) AS asset_count FROM assets WHERE is_enabled = 1 GROUP BY status ORDER BY asset_count DESC; ',
      );

      return Map<String, int>.fromIterable(results.rows,
          key: (row) => row.typedColByName<String>('status'), value: (row) => row.typedColByName<int>('asset_count'));
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<Map<String, int>> getDepartmentsCount() async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      IResultSet results = await conn.execute(
        '''
                          SELECT d.department_name, COUNT(a.asset_id) AS asset_count
                          FROM departments d
                          LEFT OUTER JOIN assets a ON d.department_id = a.department_id AND a.is_enabled = 1
                          WHERE d.is_enabled = 1
                          GROUP BY d.department_name
                          ORDER BY asset_count DESC;
                          ''',
      );

      return Map<String, int>.fromIterable(results.rows,
          key: (row) => row.typedColByName<String>('department_name'), value: (row) => row.typedColByName<int>('asset_count'));
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<Map<String, int>> getCategoriesCount() async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      IResultSet results = await conn.execute(
        '''
                          SELECT c.category_name, COUNT(a.asset_id) AS asset_count
                          FROM categories c
                          LEFT OUTER JOIN assets a ON c.category_id = a.category_id AND a.is_enabled = 1
                          WHERE c.is_enabled = 1
                          GROUP BY c.category_name
                          ORDER BY asset_count DESC;
                          ''',
      );

      return Map<String, int>.fromIterable(results.rows,
          key: (row) => row.typedColByName<String>('category_name'), value: (row) => row.typedColByName<int>('asset_count'));
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> addDepartment(String departmentName) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      await conn.execute('INSERT INTO `departments` (department_id, department_name) VALUES (:departmentID, :departmentName)', {
        'departmentName': departmentName,
        'departmentID': generateRandomID(),
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> addCategory(String categoryName) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      await conn.execute('INSERT INTO `categories` (category_id, category_name) VALUES (:categoryID, :categoryName)', {
        'categoryName': categoryName,
        'categoryID': generateRandomID(),
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> editDepartment(Department department) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      await conn.execute('UPDATE `departments` SET `department_name` = :departmentName WHERE `department_id` = :departmentID AND `is_enabled` = 1 ', {
        'departmentName': department.departmentName,
        'departmentID': department.departmentID,
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> deleteDepartment(String departmentID) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      await conn.execute(
        'UPDATE `departments` SET `is_enabled` = 0 WHERE `department_id` = :departmentID',
        {'departmentID': departmentID},
      );
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> editCategory(ItemCategory category) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();

      await conn.connect();

      await conn.execute('UPDATE `categories` SET `category_name` = :categoryName WHERE `category_id` = :categoryID AND `is_enabled` = 1 ', {
        'categoryName': category.categoryName,
        'categoryID': category.categoryID,
      });
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<void> deleteCategory(String categoryID) async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      await conn.execute(
        'UPDATE `categories` SET `is_enabled` = 0 WHERE `category_id` = :categoryID',
        {'categoryID': categoryID},
      );
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<List<Department>> getDepartments() async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();

      var results = await conn.execute('SELECT * FROM `departments` WHERE `is_enabled` = 1 ORDER BY `department_name` ASC');

      return results.rows.map((row) {
        return Department(
          departmentID: row.typedColByName<String>('department_id')!,
          departmentName: row.typedColByName<String>('department_name')!,
        );
      }).toList();
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<List<ItemCategory>> getCategories() async {
    MySQLConnection? conn;

    try {
      conn = await createSqlConn();
      await conn.connect();
      var results = await conn.execute('SELECT * FROM `categories` WHERE `is_enabled` = 1 ORDER BY `category_name` ASC');

      return results.rows.map((row) {
        return ItemCategory(
          categoryID: row.typedColByName<String>('category_id')!,
          categoryName: row.typedColByName<String>('category_name')!,
        );
      }).toList();
    } catch (e, st) {
      return await Future.error(e, st);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }
}
