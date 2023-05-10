// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String userID;
  String username;
  bool isAdmin;
  User({
    required this.userID,
    required this.username,
    required this.isAdmin,
  });

  User copyWith({
    String? userID,
    String? username,
    bool? isAdmin,
  }) {
    return User(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  String toString() =>
      'User(userID: $userID, username: $username, isAdmin: $isAdmin)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userID == userID &&
        other.username == username &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode => userID.hashCode ^ username.hashCode ^ isAdmin.hashCode;
}
