import 'package:mysql1/mysql1.dart';
import 'package:riverpod/riverpod.dart';

final sqlConnProvider = StateProvider<MySqlConnection?>((ref) {
  return null;
});
