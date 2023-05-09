import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:eon_asset_tracker/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:nanoid/nanoid.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/department_model.dart';

String hashPassword(String input) {
  return sha1.convert(utf8.encode(input)).toString();
}

String generateItemID() {
  String eonCustomAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  String randomID1 = customAlphabet(eonCustomAlphabet, 5);
  String randomID2 = customAlphabet(eonCustomAlphabet, 5);
  String randomID3 = customAlphabet(eonCustomAlphabet, 5);

  return '$randomID1-$randomID2-$randomID3';
}

Future<bool?> authenticateUser(String username, String passwordHash, MySqlConnection conn) async {
  try {
    await Future.delayed(const Duration(seconds: 1));

    Iterable results = await conn.query('SELECT * FROM `users` WHERE `username`=? and `password_hash`=?', [username, passwordHash]);

    if (results.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
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
    embeddedImage: const AssetImage('assets/logo.jpg'),
    embeddedImageStyle: QrEmbeddedImageStyle(),
  );
}

Department departmentFromID(String id, List<Department> departments) {
  return departments.firstWhere((element) => element.departmentID == id);
}

Department departmentFromName(String name, List<Department> departments) {
  return departments.firstWhere((element) => element.departmentName == name);
}

ItemCategory categoryFromID(String id, List<ItemCategory> categories) {
  return categories.firstWhere((element) => element.categoryID == id);
}

ItemCategory categoryFromName(String name, List<ItemCategory> categories) {
  return categories.firstWhere((element) => element.categoryName == name);
}
