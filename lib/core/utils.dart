import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';

String hashPassword(String input) {
  return sha1.convert(utf8.encode(input)).toString();
}

String generateItemID(String input) {
  return sha1.convert(utf8.encode(input)).toString();
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
