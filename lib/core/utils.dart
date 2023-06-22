import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:nanoid/nanoid.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../inventory_advanced_search/advanced_inventory_notifier.dart';
import '../inventory_advanced_search/notifiers.dart';
import '../notifiers/dashboard_notifiers.dart';
import 'constants.dart';
import 'providers.dart';

String hashPassword(String input) {
  return sha1.convert(utf8.encode(input)).toString();
}

Future<MySQLConnection> createSqlConn() async {
  try {
    return await MySQLConnection.createConnection(
      host: globalConnectionSettings.ip,
      port: globalConnectionSettings.port,
      userName: globalConnectionSettings.username,
      password: globalConnectionSettings.password,
      databaseName: globalConnectionSettings.databaseName,
      secure: Platform.isWindows ? true : false,
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () async => await Future.error(const SocketException('Can\'t connect to database')),
    );
  } catch (e, st) {
    return await Future.error(e, st);
  }
}

String generateRandomID() {
  String eonCustomAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  String randomID1 = customAlphabet(eonCustomAlphabet, 5);
  String randomID2 = customAlphabet(eonCustomAlphabet, 5);
  String randomID3 = customAlphabet(eonCustomAlphabet, 5);

  return '$randomID1-$randomID2-$randomID3';
}

String dateToString(DateTime dateTime) {
  return '${DateFormat.EEEE().format(dateTime)} ${DateFormat.yMMMd().format(dateTime)}';
}

String dateToReportString(DateTime dateTime) {
  return '${DateFormat.EEEE().format(dateTime)}\n${DateFormat.yMMMd().format(dateTime)}';
}

String dateTimeToString(DateTime dateTime) {
  return '${DateFormat.yMMMMEEEEd().format(dateTime)} ${DateFormat.jm().format(dateTime)}';
}

String priceToString(double? price) {
  return price == null ? '' : NumberFormat.currency(symbol: '₱ ', decimalDigits: 2).format(price);
}

String dateTimeToSQLString(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

Widget generateQRImage({required String assetID, double? size, required ThemeMode themeMode}) {
  return QrImageView(
    size: size,
    data: assetID,
    backgroundColor: Colors.transparent,
    foregroundColor: themeMode == ThemeMode.light ? Colors.black : Colors.white,
  );
}

int compareValues(double? a, double? b, {bool descending = false}) {
  if (a == null && b == null) return 0;
  if (a == null) return descending ? 1 : -1;
  if (b == null) return descending ? -1 : 1;
  return a.compareTo(b) * (descending ? -1 : 1);
}

int compareDates(DateTime? a, DateTime? b, {bool descending = false}) {
  if (a == null && b == null) return 0;
  if (a == null) return descending ? 1 : -1;
  if (b == null) return descending ? -1 : 1;
  return a.compareTo(b) * (descending ? -1 : 1);
}

int compareStrings(String? a, String? b, {bool descending = false}) {
  if (a == null && b == null) return 0;
  if (a == null) return descending ? 1 : -1;
  if (b == null) return descending ? -1 : 1;
  return a.compareTo(b) * (descending ? -1 : 1);
}

void showErrorAndStacktrace(Object e, StackTrace? st) {
  EasyLoading.showError(e.toString());
  debugPrint(e.toString());
  debugPrintStack(label: e.toString(), stackTrace: st);
}

InventorySearchFilter databaseStringToInventoryFilterEnum(String databaseString) {
  switch (databaseString) {
    case 'asset_id':
      return InventorySearchFilter.assetID;

    case 'item_name':
      return InventorySearchFilter.itemName;

    case 'person_accountable':
      return InventorySearchFilter.personAccountable;

    case 'unit':
      return InventorySearchFilter.unit;

    case 'item_description':
      return InventorySearchFilter.itemDescription;

    case 'remarks':
      return InventorySearchFilter.remarks;

    case 'status':
      return InventorySearchFilter.status;

    case 'department_id':
      return InventorySearchFilter.department;

    case 'category_id':
      return InventorySearchFilter.category;

    case 'date_purchased':
      return InventorySearchFilter.datePurchased;

    case 'date_received':
      return InventorySearchFilter.dateReceived;

    case 'price':
      return InventorySearchFilter.price;

    case 'last_scanned':
      return InventorySearchFilter.lastScanned;

    case 'property_id':
      return InventorySearchFilter.property;

    default:
      throw ArgumentError('Invalid database string: $databaseString');
  }
}

String inventoryFilterEnumToDatabaseString(InventorySearchFilter filter) {
  switch (filter) {
    case InventorySearchFilter.assetID:
      return 'asset_id';

    case InventorySearchFilter.itemName:
      return 'item_name';

    case InventorySearchFilter.personAccountable:
      return 'person_accountable';

    case InventorySearchFilter.unit:
      return 'unit';

    case InventorySearchFilter.itemDescription:
      return 'item_description';

    case InventorySearchFilter.remarks:
      return 'remarks';

    case InventorySearchFilter.status:
      return 'status';

    case InventorySearchFilter.department:
      return 'department_id';

    case InventorySearchFilter.category:
      return 'category_id';

    case InventorySearchFilter.datePurchased:
      return 'date_purchased';

    case InventorySearchFilter.dateReceived:
      return 'date_received';

    case InventorySearchFilter.price:
      return 'price';

    case InventorySearchFilter.lastScanned:
      return 'last_scanned';

    case InventorySearchFilter.property:
      return 'property_id';
  }
}

String inventoryFilterEnumToDisplayString(InventorySearchFilter filter) {
  switch (filter) {
    case InventorySearchFilter.assetID:
      return 'Asset ID';

    case InventorySearchFilter.itemName:
      return 'Item Name';

    case InventorySearchFilter.personAccountable:
      return 'Person Accountable';

    case InventorySearchFilter.unit:
      return 'Unit';

    case InventorySearchFilter.itemDescription:
      return 'Item Description';

    case InventorySearchFilter.remarks:
      return 'Remarks';

    case InventorySearchFilter.status:
      return 'Status';

    case InventorySearchFilter.department:
      return 'Department';

    case InventorySearchFilter.category:
      return 'Category';

    case InventorySearchFilter.datePurchased:
      return 'Date Purchased';

    case InventorySearchFilter.dateReceived:
      return 'Date Received';

    case InventorySearchFilter.price:
      return 'Price';

    case InventorySearchFilter.lastScanned:
      return 'Last Scanned';

    case InventorySearchFilter.property:
      return 'Property';
  }
}

int lastScannedDayCalculator(DateTime lastScannedDate) {
  DateTime currentDay = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  DateTime scannedDate = lastScannedDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  return currentDay.difference(scannedDate).inDays;
}

Text lastScannedFormatter(DateTime lastScannedDate) {
  int days = lastScannedDayCalculator(lastScannedDate);

  if (days == 0) {
    return const Text(
      'Today',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  } else {
    // example: '~10 days ago'
    return Text(
      '~$days days ago',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.red),
    );
  }
}

Future<void> refreshInventory(ref) async {
  await ref.invalidate(activeSearchFiltersNotifierProvider);
  await ref.invalidate(advancedSearchDataNotifierProvider);
  await ref.invalidate(isAdvancedFilterNotifierProvider);
  await ref.invalidate(currentInventoryPage);
  await ref.invalidate(dashboardCategoriesProvider);
  await ref.invalidate(dashboardDepartmentsProvider);
  await ref.invalidate(dashboardStatusProvider);
  await ref.invalidate(advancedInventoryNotifierProvider);
}
