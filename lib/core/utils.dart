import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:nanoid/nanoid.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/user_model.dart';

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

Future<User?> authenticateUser(String username, String passwordHash, MySqlConnection? conn) async {
  if (conn == null) return null;

  try {
    await Future.delayed(const Duration(milliseconds: 200));

    IResultSet results = await conn.query('SELECT * FROM `users` WHERE `username`=? and `password_hash`=?', [username, passwordHash]);

    if (results.isNotEmpty) {
      ResultSetRow row = results.rows.first;

      return row
          .map(
            (element) => User(
              userID: row.typedColByName<String>('user_id')!,
              username: row.typedColByName<String>('username')!,
              isAdmin: row.typedColByName<int>('is_enabled')! == 1 ? true : false,
            ),
          )
          .first;
    } else {
      return null;
    }
  } catch (e) {
    debugPrint(e.toString());
    EasyLoading.showError(e.toString());
    return Future.error('');
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
  );
}
