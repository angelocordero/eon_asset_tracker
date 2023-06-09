// ignore_for_file: public_member_api_docs, sort_constructors_first
class Department {
  String departmentID;
  String departmentName;

  Department({
    required this.departmentID,
    required this.departmentName,
  });

  Department copyWith({
    String? departmentID,
    String? departmentName,
    bool? isEnabled,
  }) {
    return Department(
      departmentID: departmentID ?? this.departmentID,
      departmentName: departmentName ?? this.departmentName,
    );
  }

  @override
  String toString() =>
      'Department(departmentID: $departmentID, departmentName: $departmentName)';

  @override
  bool operator ==(covariant Department other) {
    if (identical(this, other)) return true;

    return other.departmentID == departmentID &&
        other.departmentName == departmentName;
  }

  @override
  int get hashCode => departmentID.hashCode ^ departmentName.hashCode;
}
