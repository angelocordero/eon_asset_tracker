import '../core/utils.dart';

class Item {
  String assetID;
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
  String? remarks;

  Item({
    required this.assetID,
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
    this.remarks,
  });

  Item.withoutID({
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
    this.remarks,
  }) : assetID = generateItemID(
            '$departmentID$personAccountable$model$description$unit$price$datePurchased$dateReceived$categoryID');

  Item copyWith({
    String? assetID,
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
    String? remarks,
  }) {
    return Item(
      assetID: assetID ?? this.assetID,
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
      remarks: remarks ?? this.remarks,
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
        other.categoryID == categoryID &&
        other.remarks == remarks;
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
        status.hashCode ^
        remarks.hashCode;
  }

  @override
  String toString() {
    return 'Item(assetID: $assetID, departmentID: $departmentID, personAccountable: $personAccountable, model: $model, description: $description, unit: $unit, price: $price, datePurchased: $datePurchased, dateReceived: $dateReceived, status: $status, categoryID: $categoryID, remarks: $remarks)';
  }
}
