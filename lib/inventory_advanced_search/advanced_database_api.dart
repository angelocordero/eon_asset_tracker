// ignore_for_file: sdk_version_since

import 'package:flutter/material.dart';

import 'package:mysql_client/mysql_client.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../models/inventory_model.dart';
import '../models/item_model.dart';
import 'search_popup.dart';

class AdvancedDatabaseAPI {
  static Future<List<Item>> getItemsForReport({
    required Map<String, dynamic> searchData,
    required List<InventorySearchFilter> filters,
  }) async {
    MySQLConnection? conn;

    String itemsQueryString = _mysqlItemsQueryStringForReport(filters: filters, searchData: searchData);

    try {
      conn = await createSqlConn();
      await conn.connect();

      IResultSet result = await conn.execute(itemsQueryString);

      return result.rows.map<Item>((row) {
        return Item.fromDatabase(
          row: row,
        );
      }).toList();
    } catch (e) {
      return Future.value([]);
    } finally {
      if (conn != null && conn.connected) {
        await conn.close();
      }
    }
  }

  static Future<Inventory> advancedSearch({
    required MySQLConnection conn,
    required int page,
    required int itemsPerPage,
    required Map<String, dynamic> searchData,
    required List<InventorySearchFilter> filters,
  }) async {
    try {
      String mysqlCountQueryString = _mysqlCountQueryString(filters: filters, searchData: searchData);
      String mysqlItemsQueryString = _mysqlItemsQueryString(itemsPerPage: itemsPerPage, page: page, filters: filters, searchData: searchData);

      IResultSet countResult = await conn.execute(mysqlCountQueryString);
      IResultSet itemsResult = await conn.execute(mysqlItemsQueryString);

      int count = countResult.rows.firstOrNull?.typedColByName<int>('count') ?? 0;
      List<Item> items = itemsResult.rows
          .map<Item>(
            (row) => Item.fromDatabase(
              row: row,
            ),
          )
          .toList();

      return Inventory(items: items, count: count);
    } catch (e) {
      return await Future.error(e);
    }
  }

  static String _mysqlCountQueryString({
    required List<InventorySearchFilter> filters,
    required Map<String, dynamic> searchData,
  }) {
    String mysqlCountQueryString = 'SELECT COUNT(*) as count FROM `assets` WHERE `is_enabled` = 1 ';

    for (InventorySearchFilter element in InventorySearchFilter.values) {
      if (!filters.contains(element)) continue;

      String columnString = inventoryFilterEnumToDatabaseString(element);

      if (!searchData.containsKey(columnString.toString())) continue;

      if (element == InventorySearchFilter.department && searchData[columnString] == 'hotdog') continue;
      if (element == InventorySearchFilter.property && searchData[columnString] == 'itlog') continue;

      if (element == InventorySearchFilter.datePurchased || element == InventorySearchFilter.dateReceived) {
        DateTimeRange range = searchData[columnString];

        String from = dateTimeToSQLString(range.start);
        String to = dateTimeToSQLString(range.end);

        String filterQueryString = 'AND `$columnString` BETWEEN \'$from\' AND \'$to\' ';

        mysqlCountQueryString = '$mysqlCountQueryString $filterQueryString ';
      } else if (element == InventorySearchFilter.price) {
        (String, String) range = searchData[columnString];

        String from = range.$1;
        String to = range.$2;

        String filterQueryString = 'AND `$columnString` BETWEEN \'$from\' AND \'$to\' ';

        mysqlCountQueryString = '$mysqlCountQueryString $filterQueryString ';
      } else if (element == InventorySearchFilter.status) {
        if (searchData[columnString] == AdvancedSearchStatusEnum.All) continue;

        String query = (searchData[columnString] as AdvancedSearchStatusEnum).name;

        mysqlCountQueryString = '$mysqlCountQueryString AND `$columnString` LIKE \'%$query%\' ';
      } else if (element == InventorySearchFilter.lastScanned) {
        String query = switch (searchData[columnString] as LastScannedFilterEnum) {
          LastScannedFilterEnum.today => 'last_scanned >= CURDATE()',
          LastScannedFilterEnum.within7days => 'last_scanned >= CURDATE() - INTERVAL 7 DAY',
          LastScannedFilterEnum.within30days => 'last_scanned >= CURDATE() - INTERVAL 30 DAY',
          LastScannedFilterEnum.morethan30days => 'last_scanned < CURDATE() - INTERVAL 30 DAY',
        };

        mysqlCountQueryString = '$mysqlCountQueryString AND $query ';
      } else {
        String query = searchData[columnString];

        mysqlCountQueryString = '$mysqlCountQueryString AND $columnString LIKE \'%$query%\' ';
      }
    }

    return '$mysqlCountQueryString;';
  }

  static String _mysqlItemsQueryString({
    required int itemsPerPage,
    required int page,
    required List<InventorySearchFilter> filters,
    required Map<String, dynamic> searchData,
  }) {
    int offset = (itemsPerPage * page);

    String mysqlItemsQueryString = '''SELECT a.*, c.category_name, d.department_name, p.property_name FROM `assets` AS a
                                 JOIN `categories` AS c ON a.category_id = c.category_id
                                 JOIN `departments` AS d ON a.department_id = d.department_id
                                 JOIN `properties` AS p ON a.property_id = p.property_id
                                 WHERE  c.is_enabled = 1
                                 AND d.is_enabled = 1 
                                 AND p.is_enabled = 1 
                                 AND a.is_enabled = 1 ''';

    for (InventorySearchFilter element in InventorySearchFilter.values) {
      if (!filters.contains(element)) continue;

      String columnString = inventoryFilterEnumToDatabaseString(element);

      if (!searchData.containsKey(columnString.toString())) continue;

      if (element == InventorySearchFilter.department && searchData[columnString] == 'hotdog') continue;
      if (element == InventorySearchFilter.property && searchData[columnString] == 'itlog') continue;

      if (element == InventorySearchFilter.datePurchased || element == InventorySearchFilter.dateReceived) {
        DateTimeRange range = searchData[columnString];

        String from = dateTimeToSQLString(range.start);
        String to = dateTimeToSQLString(range.end);

        String filterQueryString = 'AND `$columnString` BETWEEN \'$from\' AND \'$to\' ';

        mysqlItemsQueryString = '$mysqlItemsQueryString $filterQueryString ';
      } else if (element == InventorySearchFilter.price) {
        (String, String) range = searchData[columnString];

        String from = range.$1;
        String to = range.$2;

        String filterQueryString = 'AND `$columnString` BETWEEN \'$from\' AND \'$to\' ';

        mysqlItemsQueryString = '$mysqlItemsQueryString $filterQueryString ';
      } else if (element == InventorySearchFilter.status) {
        if (searchData[columnString] == AdvancedSearchStatusEnum.All) continue;

        String query = (searchData[columnString] as AdvancedSearchStatusEnum).name;

        mysqlItemsQueryString = '$mysqlItemsQueryString AND `$columnString` LIKE \'%$query%\' ';
      } else if (element == InventorySearchFilter.lastScanned) {
        String query = switch (searchData[columnString] as LastScannedFilterEnum) {
          LastScannedFilterEnum.today => 'last_scanned >= CURDATE()',
          LastScannedFilterEnum.within7days => 'last_scanned >= CURDATE() - INTERVAL 7 DAY',
          LastScannedFilterEnum.within30days => 'last_scanned >= CURDATE() - INTERVAL 30 DAY',
          LastScannedFilterEnum.morethan30days => 'last_scanned < CURDATE() - INTERVAL 30 DAY'
        };

        mysqlItemsQueryString = '$mysqlItemsQueryString AND $query ';
      } else {
        String query = searchData[columnString];

        mysqlItemsQueryString = '$mysqlItemsQueryString AND a.$columnString LIKE \'%$query%\' ';
      }
    }

    return '$mysqlItemsQueryString ORDER BY `timestamp` DESC, `item_name` ASC LIMIT $itemsPerPage OFFSET $offset;';
  }

  static String _mysqlItemsQueryStringForReport({
    required List<InventorySearchFilter> filters,
    required Map<String, dynamic> searchData,
  }) {
    String mysqlItemsQueryString = '''SELECT a.*, c.category_name, d.department_name, p.property_name FROM `assets` AS a
                                 JOIN `categories` AS c ON a.category_id = c.category_id
                                 JOIN `departments` AS d ON a.department_id = d.department_id
                                 JOIN `properties` AS p ON a.property_id = p.property_id
                                 WHERE  c.is_enabled = 1
                                 AND d.is_enabled = 1
                                 AND p.is_enabled = 1 
                                 AND a.is_enabled = 1 ''';

    for (InventorySearchFilter element in InventorySearchFilter.values) {
      if (!filters.contains(element)) continue;

      String columnString = inventoryFilterEnumToDatabaseString(element);

      if (!searchData.containsKey(columnString.toString())) continue;

      if (element == InventorySearchFilter.department && searchData[columnString] == 'hotdog') continue;
      if (element == InventorySearchFilter.property && searchData[columnString] == 'itlog') continue;

      if (element == InventorySearchFilter.datePurchased || element == InventorySearchFilter.dateReceived) {
        DateTimeRange range = searchData[columnString];

        String from = dateTimeToSQLString(range.start);
        String to = dateTimeToSQLString(range.end);

        String filterQueryString = 'AND `$columnString` BETWEEN \'$from\' AND \'$to\' ';

        mysqlItemsQueryString = '$mysqlItemsQueryString $filterQueryString ';
      } else if (element == InventorySearchFilter.price) {
        (String, String) range = searchData[columnString];

        String from = range.$1;
        String to = range.$2;

        String filterQueryString = 'AND `$columnString` BETWEEN \'$from\' AND \'$to\' ';

        mysqlItemsQueryString = '$mysqlItemsQueryString $filterQueryString ';
      } else if (element == InventorySearchFilter.status) {
        if (searchData[columnString] == AdvancedSearchStatusEnum.All) continue;

        String query = (searchData[columnString] as AdvancedSearchStatusEnum).name;

        mysqlItemsQueryString = '$mysqlItemsQueryString AND `$columnString` LIKE \'%$query%\' ';
      } else if (element == InventorySearchFilter.lastScanned) {
        String query = switch (searchData[columnString] as LastScannedFilterEnum) {
          LastScannedFilterEnum.today => 'last_scanned >= CURDATE()',
          LastScannedFilterEnum.within7days => 'last_scanned >= CURDATE() - INTERVAL 7 DAY',
          LastScannedFilterEnum.within30days => 'last_scanned >= CURDATE() - INTERVAL 30 DAY',
          LastScannedFilterEnum.morethan30days => 'last_scanned < CURDATE() - INTERVAL 30 DAY'
        };

        mysqlItemsQueryString = '$mysqlItemsQueryString AND $query ';
      } else {
        String query = searchData[columnString];

        mysqlItemsQueryString = '$mysqlItemsQueryString AND a.$columnString LIKE \'%$query%\' ';
      }
    }

    return '$mysqlItemsQueryString ORDER BY `timestamp` DESC, `item_name` ASC;';
  }
}
