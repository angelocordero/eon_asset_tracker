// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemCategory {
  String categoryID;
  String categoryName;
  bool isEnabled;
  ItemCategory({
    required this.categoryID,
    required this.categoryName,
    required this.isEnabled,
  });

  ItemCategory copyWith({
    String? categoryID,
    String? categoryName,
    bool? isEnabled,
  }) {
    return ItemCategory(
      categoryID: categoryID ?? this.categoryID,
      categoryName: categoryName ?? this.categoryName,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  String toString() =>
      'Category(categoryID: $categoryID, categorName: $categoryName, isEnabled: $isEnabled)';

  @override
  bool operator ==(covariant ItemCategory other) {
    if (identical(this, other)) return true;

    return other.categoryID == categoryID &&
        other.categoryName == categoryName &&
        other.isEnabled == isEnabled;
  }

  @override
  int get hashCode =>
      categoryID.hashCode ^ categoryName.hashCode ^ isEnabled.hashCode;
}
