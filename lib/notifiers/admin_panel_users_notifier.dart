import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database_api.dart';
import '../core/utils.dart';
import '../models/user_model.dart';

part 'admin_panel_users_notifier.g.dart';

@Riverpod(keepAlive: true)
class AdminPanelUsersNotifier extends _$AdminPanelUsersNotifier {
  @override
  FutureOr<List<User>> build() async {
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

    await AsyncValue.guard(() async {
      await DatabaseAPI.addUser(user, password);
    });

    ref.invalidateSelf();
  }

  Future<void> editUser(User user) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      await DatabaseAPI.editUser(user);
    });

    ref.invalidateSelf();
  }

  Future<void> deleteUser(User user) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      await DatabaseAPI.deleteUser(user);
    });

    ref.invalidateSelf();
  }

  Future<void> resetPassword(User user, String newPassword) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      await DatabaseAPI.resetPassword(user, newPassword);
    });

    ref.invalidateSelf();
  }
}
