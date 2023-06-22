// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemCategory {
  ItemCategory({
    required this.categoryID,
    required this.categoryName,
  });

  String? categoryID;
  String categoryName;

  @override
  bool operator ==(covariant ItemCategory other) {
    if (identical(this, other)) return true;

    return other.categoryID == categoryID && other.categoryName == categoryName;
  }

  @override
  int get hashCode => categoryID.hashCode ^ categoryName.hashCode;

  @override
  String toString() => 'Category(categoryID: $categoryID, categoryName: $categoryName)';

  ItemCategory copyWith({
    String? categoryID,
    String? categoryName,
  }) {
    return ItemCategory(
      categoryID: categoryID ?? this.categoryID,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
