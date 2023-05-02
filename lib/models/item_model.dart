// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eon_asset_tracker/core/utils.dart';

class Item {
  late String assetID;
  String departmentID;
  String? personAccountable;
  String model;
  String? description;
  String unit;
  double? price;
  DateTime? datePurchased;
  DateTime? dateReceived;
  String status;
  String categoryID;

  Item({
    required this.departmentID,
    this.personAccountable,
    required this.model,
    this.description,
    required this.unit,
    this.price,
    this.datePurchased,
    this.dateReceived,
    required this.status,
    required this.categoryID,
  }) {
    String itemIDSeed =
        '$departmentID+$personAccountable+$model+$description+$unit+$price+$datePurchased+$dateReceived+$categoryID';
    assetID = generateItemID(itemIDSeed);
    print(assetID);
    print(itemIDSeed);
  }

  Item copyWith({
    String? departmentID,
    String? personAccountable,
    String? model,
    String? description,
    String? unit,
    double? price,
    DateTime? datePurchased,
    DateTime? dateReceived,
    String? status,
    String? categoryID,
  }) {
    return Item(
      departmentID: departmentID ?? this.departmentID,
      personAccountable: personAccountable ?? this.personAccountable,
      model: model ?? this.model,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      datePurchased: datePurchased ?? this.datePurchased,
      dateReceived: dateReceived ?? this.dateReceived,
      status: status ?? this.status,
      categoryID: categoryID ?? this.categoryID,
    );
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.assetID == assetID &&
        other.departmentID == departmentID &&
        other.personAccountable == personAccountable &&
        other.model == model &&
        other.description == description &&
        other.unit == unit &&
        other.price == price &&
        other.datePurchased == datePurchased &&
        other.dateReceived == dateReceived &&
        other.status == status &&
        other.categoryID == categoryID;
  }

  @override
  int get hashCode {
    return assetID.hashCode ^
        departmentID.hashCode ^
        personAccountable.hashCode ^
        model.hashCode ^
        description.hashCode ^
        unit.hashCode ^
        price.hashCode ^
        datePurchased.hashCode ^
        dateReceived.hashCode ^
        categoryID.hashCode ^
        status.hashCode;
  }

  @override
  String toString() {
    return 'Item(assetID: $assetID, departmentID: $departmentID, personAccountable: $personAccountable, model: $model, description: $description, unit: $unit, price: $price, datePurchased: $datePurchased, dateReceived: $dateReceived, status: $status, categoryID: $categoryID)';
  }
}
