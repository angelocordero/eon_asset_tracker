import '../core/utils.dart';

class Item {
  String assetID;
  String department;
  String? personAccountable;
  String model;
  String? description;
  String unit;
  double? price;
  DateTime? datePurchased;
  DateTime? dateReceived;
  String status;
  String category;
  String? remarks;

  Item({
    required this.assetID,
    required this.department,
    this.personAccountable,
    required this.model,
    this.description,
    required this.unit,
    this.price,
    this.datePurchased,
    this.dateReceived,
    required this.status,
    required this.category,
    this.remarks,
  });

  Item.withoutID({
    required this.department,
    this.personAccountable,
    required this.model,
    this.description,
    required this.unit,
    this.price,
    this.datePurchased,
    this.dateReceived,
    required this.status,
    required this.category,
    this.remarks,
  }) : assetID = generateItemID(
            '$department$personAccountable$model$description$unit$price$datePurchased$dateReceived$category');

  Item copyWith({
    String? assetID,
    String? department,
    String? personAccountable,
    String? model,
    String? description,
    String? unit,
    double? price,
    DateTime? datePurchased,
    DateTime? dateReceived,
    String? status,
    String? category,
    String? remarks,
  }) {
    return Item(
      assetID: assetID ?? this.assetID,
      department: department ?? this.department,
      personAccountable: personAccountable ?? this.personAccountable,
      model: model ?? this.model,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      datePurchased: datePurchased ?? this.datePurchased,
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
        other.model == model &&
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
        model.hashCode ^
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
    return 'Item(assetID: $assetID, department: $department, personAccountable: $personAccountable, model: $model, description: $description, unit: $unit, price: $price, datePurchased: $datePurchased, dateReceived: $dateReceived, status: $status, category: $category, remarks: $remarks)';
  }
}
