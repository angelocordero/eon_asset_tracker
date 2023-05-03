// ignore_for_file: public_member_api_docs, sort_constructors_first
class Department {
  String departmentID;
  String departmentName;
  bool isEnabled;

  Department({
    required this.departmentID,
    required this.departmentName,
    required this.isEnabled,
  });

  Department copyWith({
    String? departmentID,
    String? departmentName,
    bool? isEnabled,
  }) {
    return Department(
      departmentID: departmentID ?? this.departmentID,
      departmentName: departmentName ?? this.departmentName,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  String toString() =>
      'Department(departmentID: $departmentID, departmentName: $departmentName, isEnabled: $isEnabled)';

  @override
  bool operator ==(covariant Department other) {
    if (identical(this, other)) return true;

    return other.departmentID == departmentID &&
        other.departmentName == departmentName &&
        other.isEnabled == isEnabled;
  }

  @override
  int get hashCode =>
      departmentID.hashCode ^ departmentName.hashCode ^ isEnabled.hashCode;
}
