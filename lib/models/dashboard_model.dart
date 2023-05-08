// ignore_for_file: public_member_api_docs, sort_constructors_first
typedef CategoriesDashboardData = List<Map<String, dynamic>>;
typedef DepartmentsDashboardData = List<Map<String, dynamic>>;
typedef StatusDashboardData = Map<String, int>;

class DashboardData {
  StatusDashboardData statusDashboardData;
  CategoriesDashboardData categoriesDashbordData;
  DepartmentsDashboardData departmentsDashboardData;

  DashboardData({
    required this.statusDashboardData,
    required this.categoriesDashbordData,
    required this.departmentsDashboardData,
  });

  factory DashboardData.empty() {
    return DashboardData(
      statusDashboardData: {},
      categoriesDashbordData: [],
      departmentsDashboardData: [],
    );
  }

  DashboardData copyWith({
    StatusDashboardData? statusDashboardData,
    CategoriesDashboardData? categoriesDashbordData,
    DepartmentsDashboardData? departmentsDashboardData,
  }) {
    return DashboardData(
      statusDashboardData: statusDashboardData ?? this.statusDashboardData,
      categoriesDashbordData:
          categoriesDashbordData ?? this.categoriesDashbordData,
      departmentsDashboardData:
          departmentsDashboardData ?? this.departmentsDashboardData,
    );
  }

  @override
  String toString() =>
      'DashboardData(statusDashboardData: $statusDashboardData, categoriesDashbordData: $categoriesDashbordData, departmentsDashboardData: $departmentsDashboardData)';

  @override
  bool operator ==(covariant DashboardData other) {
    if (identical(this, other)) return true;

    return other.statusDashboardData == statusDashboardData &&
        other.categoriesDashbordData == categoriesDashbordData &&
        other.departmentsDashboardData == departmentsDashboardData;
  }

  @override
  int get hashCode =>
      statusDashboardData.hashCode ^
      categoriesDashbordData.hashCode ^
      departmentsDashboardData.hashCode;
}
