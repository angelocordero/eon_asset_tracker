import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:eon_asset_tracker/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';
import 'package:qr_flutter/qr_flutter.dart';

String hashPassword(String input) {
  return sha1.convert(utf8.encode(input)).toString();
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

QrImageView generateQRImage({required String assetID, double? size}) {
  return QrImageView(
    size: size,
    data: assetID,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
  );
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

    default:
      return null;
  }
}
