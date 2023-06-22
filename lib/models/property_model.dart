// ignore_for_file: public_member_api_docs, sort_constructors_first
class Property {
  String? propertyID;
  String propertyName;
  Property({
    required this.propertyID,
    required this.propertyName,
  });

  Property copyWith({
    String? propertyID,
    String? propertyName,
  }) {
    return Property(
      propertyID: propertyID ?? this.propertyID,
      propertyName: propertyName ?? this.propertyName,
    );
  }

  @override
  String toString() => 'Category(propertyID: $propertyID, propertyName: $propertyName)';

  @override
  bool operator ==(covariant Property other) {
    if (identical(this, other)) return true;

    return other.propertyID == propertyID && other.propertyName == propertyName;
  }

  @override
  int get hashCode => propertyID.hashCode ^ propertyName.hashCode;
}
