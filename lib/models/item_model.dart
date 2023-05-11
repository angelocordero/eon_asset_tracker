import 'package:eon_asset_tracker/core/utils.dart';
import 'package:mysql_client/mysql_client.dart';

import '../core/constants.dart';
import 'category_model.dart';
import 'department_model.dart';

class Item {
  String assetID;
  Department department;
  String? personAccountable;
  String name;
  String? description;
  String? unit;
  double? price;
  DateTime? datePurchased;
  DateTime dateReceived;
  ItemStatus status;
  ItemCategory category;
  String? remarks;

  Item({
    required this.assetID,
    required this.department,
    this.personAccountable,
    required this.name,
    this.description,
    this.unit,
    this.price,
    this.datePurchased,
    required this.dateReceived,
    required this.status,
    required this.category,
    this.remarks,
  });

  // Item.toDatabase({
  //   required this.department,
  //   this.personAccountable,
  //   required this.name,
  //   this.description,
  //   required this.unit,
  //   this.price,
  //   this.datePurchased,
  //   required this.dateReceived,
  //   required this.status,
  //   required this.category,
  //   this.remarks,
  // }) : assetID = generateItemID();

  factory Item.toDatabase({
    required Department department,
    String? personAccountable,
    required String name,
    String? description,
    required String unit,
    double? price,
    DateTime? datePurchased,
    required DateTime dateReceived,
    required ItemStatus status,
    required ItemCategory category,
    String? remarks,
    required List<ItemCategory> categories,
    required List<Department> departments,
  }) {
    return Item(
      assetID: generateItemID(),
      department: department,
      personAccountable: personAccountable,
      name: name,
      description: description,
      unit: unit,
      price: price,
      datePurchased: datePurchased,
      dateReceived: dateReceived,
      status: status,
      category: category,
      remarks: remarks,
    );
  }

  factory Item.fromDatabase({
    required ResultSetRow row,
    required List<ItemCategory> categories,
    required List<Department> departments,
  }) {
    return Item(
      assetID: row.typedColByName<String>('asset_id')!,
      department: departments.firstWhere((element) => element.departmentID == row.typedColByName<String>('department_id')),
      personAccountable: row.typedColByName<String?>('person_accountable'),
      name: row.typedColByName<String>('item_name')!,
      description: row.typedColByName<String?>('item_description'),
      unit: row.typedColByName<String?>('unit'),
      price: row.typedColByName<double?>('price'),
      datePurchased:  row.typedColByName<DateTime?>('date_purchased')?.toLocal() ,
      dateReceived: row.typedColByName<DateTime>('date_received')!.toLocal(),
      status: ItemStatus.values.byName(row.typedColByName<String>('status')!),
      category: categories.firstWhere((element) => element.categoryID == row.typedColByName<String>('category')!),
      remarks: row.typedColByName<String?>('remarks'),
    );
  }

  Item copyWith({
    String? assetID,
    Department? department,
    String? personAccountable,
    String? name,
    String? description,
    String? unit,
    double? price,
    DateTime? datePurchased,
    DateTime? dateReceived,
    ItemStatus? status,
    ItemCategory? category,
    String? remarks,
  }) {
    return Item(
      assetID: assetID ?? this.assetID,
      department: department ?? this.department,
      personAccountable: personAccountable ?? this.personAccountable,
      name: name ?? this.name,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      price: price,
      datePurchased: datePurchased,
      dateReceived: dateReceived ?? this.dateReceived,
      status: status ?? this.status,
      category: category ?? this.category,
      remarks: remarks ?? this.remarks,
    );
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.assetID == assetID &&
        other.department == department &&
        other.personAccountable == personAccountable &&
        other.name == name &&
        other.description == description &&
        other.unit == unit &&
        other.price == price &&
        other.datePurchased == datePurchased &&
        other.dateReceived == dateReceived &&
        other.status == status &&
        other.category == category &&
        other.remarks == remarks;
  }

  @override
  int get hashCode {
    return assetID.hashCode ^
        department.hashCode ^
        personAccountable.hashCode ^
        name.hashCode ^
        description.hashCode ^
        unit.hashCode ^
        price.hashCode ^
        datePurchased.hashCode ^
        dateReceived.hashCode ^
        category.hashCode ^
        status.hashCode ^
        remarks.hashCode;
  }

  @override
  String toString() {
    return 'Item(assetID: $assetID, department: $department, personAccountable: $personAccountable, name: $name, description: $description, unit: $unit, price: $price, datePurchased: $datePurchased, dateReceived: $dateReceived, status: $status, category: $category, remarks: $remarks)';
  }
}
