// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemCategory {
  String? categoryID;
  String categoryName;
  ItemCategory({
    required this.categoryID,
    required this.categoryName,
  });

  ItemCategory copyWith({
    String? categoryID,
    String? categoryName,
  }) {
    return ItemCategory(
      categoryID: categoryID ?? this.categoryID,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  String toString() =>
      'Category(categoryID: $categoryID, categorName: $categoryName)';

  @override
  bool operator ==(covariant ItemCategory other) {
    if (identical(this, other)) return true;

    return other.categoryID == categoryID && other.categoryName == categoryName;
  }

  @override
  int get hashCode => categoryID.hashCode ^ categoryName.hashCode;
}
