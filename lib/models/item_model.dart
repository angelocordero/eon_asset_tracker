import 'package:mysql_client/mysql_client.dart';

import '../core/constants.dart';
import '../core/utils.dart';
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
      assetID: generateRandomID(),
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
  }) {
    Department department = Department(
        departmentID: row.typedColByName<String>('department_id')!,
        departmentName: row.typedColByName<String>('department_name')!);
    ItemCategory category = ItemCategory(
        categoryID: row.typedColByName<String>('category_id')!,
        categoryName: row.typedColByName<String>('category_name')!);

    return Item(
      assetID: row.typedColByName<String>('asset_id')!,
      department: department,
      personAccountable: row.colByName('person_accountable'),
      name: row.typedColByName<String>('item_name')!,
      description: row.colByName('item_description'),
      unit: row.colByName('unit'),
      price: row.colByName('price') == null
          ? null
          : double.tryParse((row.colByName('price')) as String),
      dateReceived: DateTime.parse(row.colByName('date_received').toString()),
      datePurchased: row.colByName('date_purchased') == null
          ? null
          : DateTime.tryParse((row.colByName('date_purchased') as String))!,
      status: ItemStatus.values.byName(row.typedColByName<String>('status')!),
      remarks: row.colByName('remarks'),
      category: category,
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
