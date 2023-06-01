// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:nanoid/nanoid.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Project imports:
import 'constants.dart';

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

String dateTimeToString(DateTime dateTime) {
  return '${DateFormat.yMMMMEEEEd().format(dateTime)} ${DateFormat.jm().format(dateTime)}';
}

String priceToString(double? price) {
  return price == null ? '' : NumberFormat.currency(symbol: '₱ ', decimalDigits: 2).format(price);
}

String dateTimeToSQLString(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}

Widget generateQRImage({required String assetID, double? size}) {
  return QrImageView(
    size: size,
    data: assetID,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
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
  // if (e.toString().contains('didChangeDependency')) {
  //   EasyLoading.dismiss();
  // } else {
  // }

  EasyLoading.showError(e.toString());
  debugPrint(e.toString());
  debugPrintStack(label: e.toString(), stackTrace: st);
}

String? inventoryFilterEnumToDatabaseString(InventorySearchFilter filter) {
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

    default:
      return null;
  }
}

String? inventoryFilterEnumToDisplayString(InventorySearchFilter filter) {
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

    default:
      return null;
  }
}
