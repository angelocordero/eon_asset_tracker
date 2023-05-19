// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:mysql_client/mysql_client.dart';

import 'department_model.dart';

class User {
  String userID;
  String username;
  bool isAdmin;
  Department? department;
  User({
    required this.userID,
    required this.username,
    required this.isAdmin,
    required this.department,
  });

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
    );
  }

  factory User.toDatabase({
    required String username,
    required Department department,
    required String status,
  }) {
    return User(
      userID: generateRandomID(),
      username: username,
      isAdmin: status == 'Admin',
      department: department,
    );
  }

  User copyWith({
    String? userID,
    String? username,
    bool? isAdmin,
    Department? department,
  }) {
    return User(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      isAdmin: isAdmin ?? this.isAdmin,
      department: department ?? this.department,
    );
  }

  @override
  String toString() => 'User(userID: $userID, username: $username, isAdmin: $isAdmin, department: $department)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userID == userID && other.username == username && other.isAdmin == isAdmin;
  }

  @override
  int get hashCode => userID.hashCode ^ username.hashCode ^ isAdmin.hashCode;
}
