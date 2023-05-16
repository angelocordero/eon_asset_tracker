// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

Future<MySQLConnection> createSqlConn() async {
  try {
    return await MySQLConnection.createConnection(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: 'cordero12',
      databaseName: 'eon',
      secure: false,
    );
  } catch (e, st) {
    return Future.error(e, st);
  }
}

enum ItemStatus {
  Good,
  Defective,
}

BorderRadius defaultBorderRadius = BorderRadius.circular(8);

int itemsPerPage = 50;

const List<Color> sampleColors = [
  Color(0xffdd7878),
  Color(0xffea76cb),
  Color(0xff8839ef),
  Color(0xff40a02b),
  Color(0xffe64553),
  Color(0xffe64553),
  Color(0xfffe640b),
  Color(0xff04a5e5),
  Color(0xff7287fd),
  Color(0xff04a5e5),
];

enum InventorySearchFilter {
  assetID,
  itemName,
  personAccountable,
  unit,
  itemDescription,
  remarks,
  status,
  department,
  category,
}
