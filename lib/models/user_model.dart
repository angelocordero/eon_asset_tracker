// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mysql_client/mysql_client.dart';

import '../core/utils.dart';
import 'department_model.dart';
import 'property_model.dart';

class User {
  User({
    required this.userID,
    required this.username,
    required this.isAdmin,
    required this.department,
    required this.property,
  });

  Department department;
  Property property;
  bool isAdmin;
  String userID;
  String username;

  factory User.fromDatabase(
    ResultSetRow row,
  ) {
    return User(
      userID: row.typedColByName<String>('user_id')!,
      username: row.typedColByName<String>('username')!,
      isAdmin: row.typedColByName<int>('admin') == 1 ? true : false,
      department: Department(
        departmentID: row.typedColByName<String>('department_id')!,
        departmentName: row.typedColByName<String>('department_name')!,
      ),
      property: Property(
        propertyID: row.typedColByName<String>('property_id')!,
        propertyName: row.typedColByName<String>('property_name')!,
      ),
    );
  }

  factory User.toDatabase({
    required String username,
    required Department department,
    required String status,
    required Property property,
  }) {
    return User(
      userID: generateRandomID(),
      username: username,
      isAdmin: status == 'Admin',
      department: department,
      property: property,
    );
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userID == userID && other.username == username && other.isAdmin == isAdmin && other.property == property;
  }

  @override
  int get hashCode => userID.hashCode ^ username.hashCode ^ isAdmin.hashCode & property.hashCode;

  @override
  String toString() => 'User(userID: $userID, username: $username, isAdmin: $isAdmin, department: $department, property: $property)';

  User copyWith({
    String? userID,
    String? username,
    bool? isAdmin,
    Department? department,
    Property? property,
  }) {
    return User(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      isAdmin: isAdmin ?? this.isAdmin,
      department: department ?? this.department,
      property: property ?? this.property,
    );
  }
}
