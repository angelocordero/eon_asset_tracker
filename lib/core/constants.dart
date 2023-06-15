// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import '../models/connection_settings_model.dart';

enum ItemStatus {
  Good,
  Defective,
  Unknown,
}

typedef TableSort = ({TableColumn? tableColumn, SortOrder? sortOrder});

ConnectionSettings globalConnectionSettings = ConnectionSettings.empty();

Box settingsBox = Hive.box('settings');

List<int> secureKey = [
  213,
  66,
  81,
  33,
  169,
  64,
  141,
  228,
  109,
  89,
  3,
  51,
  152,
  108,
  8,
  222,
  78,
  170,
  6,
  45,
  238,
  169,
  200,
  5,
  24,
  55,
  95,
  15,
  177,
  250,
  141,
  152
];

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
  Color(0xffb4befe),
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

enum TableColumn {
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

enum SortOrder {
  ascending,
  descending,
}
