import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ConnectionSettings {
  String databaseName;
  String username;
  String password;
  String ip;
  int port;
  ConnectionSettings({
    required this.databaseName,
    required this.username,
    required this.password,
    required this.ip,
    required this.port,
  });

  factory ConnectionSettings.empty() {
    return ConnectionSettings(
        databaseName: '', username: '', password: '', ip: '', port: 0);
  }

  ConnectionSettings copyWith({
    String? databaseName,
    String? username,
    String? password,
    String? ip,
    int? port,
  }) {
    return ConnectionSettings(
      databaseName: databaseName ?? this.databaseName,
      username: username ?? this.username,
      password: password ?? this.password,
      ip: ip ?? this.ip,
      port: port ?? this.port,
    );
  }

  @override
  String toString() {
    return 'ConnectionSettings(databaseName: $databaseName, username: $username, password: $password, ip: $ip, port: $port)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'databaseName': databaseName,
      'username': username,
      'password': password,
      'ip': ip,
      'port': port,
    };
  }

  factory ConnectionSettings.fromMap(Map<String, dynamic> map) {
    return ConnectionSettings(
      databaseName: map['databaseName'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      ip: map['ip'] as String,
      port: map['port'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConnectionSettings.fromJson(String source) =>
      ConnectionSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ConnectionSettings other) {
    if (identical(this, other)) return true;

    return other.databaseName == databaseName &&
        other.username == username &&
        other.password == password &&
        other.ip == ip &&
        other.port == port;
  }

  @override
  int get hashCode {
    return databaseName.hashCode ^
        username.hashCode ^
        password.hashCode ^
        ip.hashCode ^
        port.hashCode;
  }
}
