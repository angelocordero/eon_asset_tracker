import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/utils.dart';
import '../models/user_model.dart';

part 'admin_panel_users_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminPanelUsersNotifier extends _$AdminPanelUsersNotifier {
  @override
  FutureOr<List<User>> build() async {
    state = const AsyncLoading();
    return await DatabaseAPI.getUsers();
  }

  Future<void> addUser(
    User user,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      String e = 'Passwords do not match';
      StackTrace st = StackTrace.current;

      showErrorAndStacktrace(e, st);
    }

    state = const AsyncLoading();

    try {
      await DatabaseAPI.addUser(user, password);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }

  Future<void> editUser(User user) async {
    state = const AsyncLoading();

    try {
      await DatabaseAPI.editUser(user);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }

  Future<void> deleteUser(User user) async {
    state = const AsyncLoading();

    try {
      await DatabaseAPI.deleteUser(user);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }

  Future<void> resetPassword(User user, String newPassword) async {
    state = const AsyncLoading();

    try {
      await DatabaseAPI.resetPassword(user, newPassword);
    } catch (e, st) {
      showErrorAndStacktrace(e, st);
    }

    ref.invalidateSelf();
  }
}
