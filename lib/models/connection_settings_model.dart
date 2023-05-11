// ignore_for_file: public_member_api_docs, sort_constructors_first
class ConnectionSettings {
  String host;
  int port;
  String user;
  String password;
  String database;
  ConnectionSettings({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.database,
  });

  ConnectionSettings copyWith({
    String? host,
    int? port,
    String? user,
    String? password,
    String? database,
  }) {
    return ConnectionSettings(
      host: host ?? this.host,
      port: port ?? this.port,
      user: user ?? this.user,
      password: password ?? this.password,
      database: database ?? this.database,
    );
  }

  @override
  String toString() {
    return 'ConnectionSettingsModel(host: $host, port: $port, user: $user, password: $password, database: $database)';
  }

  @override
  bool operator ==(covariant ConnectionSettings other) {
    if (identical(this, other)) return true;

    return other.host == host && other.port == port && other.user == user && other.password == password && other.database == database;
  }

  @override
  int get hashCode {
    return host.hashCode ^ port.hashCode ^ user.hashCode ^ password.hashCode ^ database.hashCode;
  }
}