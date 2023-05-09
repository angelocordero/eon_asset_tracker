import 'package:mysql1/mysql1.dart';

import '../core/constants.dart';
import '../core/utils.dart';

class Item {
  String assetID;
  String departmentID;
  String? personAccountable;
  String name;
  String? description;
  String unit;
  double? price;
  DateTime? datePurchased;
  DateTime dateReceived;
  ItemStatus status;
  String categoryID;
  String? remarks;

  Item({
    required this.assetID,
    required this.departmentID,
    this.personAccountable,
    required this.name,
    this.description,
    required this.unit,
    this.price,
    this.datePurchased,
    required this.dateReceived,
    required this.status,
    required this.categoryID,
    this.remarks,
  });

  Item.withoutID({
    required this.departmentID,
    this.personAccountable,
    required this.name,
    this.description,
    required this.unit,
    this.price,
    this.datePurchased,
    required this.dateReceived,
    required this.status,
    required this.categoryID,
    this.remarks,
  }) : assetID = generateItemID();

  factory Item.fromResultRow(ResultRow row) {
    return Item(
        assetID: row[0],
        departmentID: row[1],
        personAccountable: row[2],
        name: row[3],
        description: row[4],
        unit: row[5],
        price: row[6],
        datePurchased: row[7] == null ? null : (row[7] as DateTime),
        dateReceived: (row[8] as DateTime).toLocal(),
        status: ItemStatus.values.byName(row[9]),
        categoryID: row[10],
        remarks: row[11]);
  }

  Item copyWith({
    String? assetID,
    String? departmentID,
    String? personAccountable,
    String? name,
    String? description,
    String? unit,
    double? price,
    DateTime? datePurchased,
    DateTime? dateReceived,
    ItemStatus? status,
    String? categoryID,
    String? remarks,
  }) {
    return Item(
      assetID: assetID ?? this.assetID,
      departmentID: departmentID ?? this.departmentID,
      personAccountable: personAccountable ?? this.personAccountable,
      name: name ?? this.name,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      price: price,
      datePurchased: datePurchased,
      dateReceived: dateReceived ?? this.dateReceived,
      status: status ?? this.status,
      categoryID: categoryID ?? this.categoryID,
      remarks: remarks ?? this.remarks,
    );
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.assetID == assetID &&
        other.departmentID == departmentID &&
        other.personAccountable == personAccountable &&
        other.name == name &&
        other.description == description &&
        other.unit == unit &&
        other.price == price &&
        other.datePurchased == datePurchased &&
        other.dateReceived == dateReceived &&
        other.status == status &&
        other.categoryID == categoryID &&
        other.remarks == remarks;
  }

  @override
  int get hashCode {
    return assetID.hashCode ^
        departmentID.hashCode ^
        personAccountable.hashCode ^
        name.hashCode ^
        description.hashCode ^
        unit.hashCode ^
        price.hashCode ^
        datePurchased.hashCode ^
        dateReceived.hashCode ^
        categoryID.hashCode ^
        status.hashCode ^
        remarks.hashCode;
  }

  @override
  String toString() {
    return 'Item(assetID: $assetID, departmentID: $departmentID, personAccountable: $personAccountable, name: $name, description: $description, unit: $unit, price: $price, datePurchased: $datePurchased, dateReceived: $dateReceived, status: $status, categoryID: $categoryID, remarks: $remarks)';
  }
}
