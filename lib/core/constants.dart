// ignore_for_file: constant_identifier_names

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:mysql_client/mysql_client.dart';

Future<MySQLConnection> createSqlConn() async {
  try {
    return await MySQLConnection.createConnection(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: 'root',
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

typedef TableSort = (Columns?, Sort?);

BorderRadius defaultBorderRadius = BorderRadius.circular(8);

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
  datePurchased,
  dateReceived,
}

enum Columns {
  assetID,
  itemName,
  departmentName,
  personAccountable,
  category,
  status,
  unit,
  price,
  datePurchased,
  dateReceived,
}

enum Sort {
  ascending,
  descending,
}
