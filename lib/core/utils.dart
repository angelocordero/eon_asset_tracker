import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:nanoid/nanoid.dart';

String hashPassword(String input) {
  return sha1.convert(utf8.encode(input)).toString();
}

String generateItemID() {
  String eonCustomAlphabet =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  String randomID1 = customAlphabet(eonCustomAlphabet, 5);
  String randomID2 = customAlphabet(eonCustomAlphabet, 5);
  String randomID3 = customAlphabet(eonCustomAlphabet, 5);

  return '$randomID1-$randomID2-$randomID3';
}

Future<bool?> authenticateUser(
    String username, String passwordHash, MySqlConnection conn) async {
  try {
    await Future.delayed(const Duration(seconds: 1));

    Iterable results = await conn.query(
        'SELECT * FROM `users` WHERE `username`=? and `password_hash`=?',
        [username, passwordHash]);

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

String priceToString(double? price) {
  return price == null
      ? ''
      : NumberFormat.currency(symbol: '₱ ', decimalDigits: 2).format(price);
}
