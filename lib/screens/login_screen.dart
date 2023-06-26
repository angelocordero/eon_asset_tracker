import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import '../core/constants.dart';
import '../core/database_api.dart';
import '../core/providers.dart';
import '../core/utils.dart';
import '../models/connection_settings_model.dart';
import '../models/user_model.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static final TextEditingController usernameController = TextEditingController();
  static final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    usernameController.clear();
    passwordController.clear();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () async {
          Navigator.pushNamed(context, 'connection_settings');
        },
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('U S E R   L O G I N'),
                const SizedBox(
                  height: 20,
                ),
                usernameField(),
                const SizedBox(
                  height: 20,
                ),
                passwordField(context, ref),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await authenticate(context, ref);
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Username: '),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 150,
          child: TextField(
            autofocus: true,
            controller: usernameController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget passwordField(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Password: '),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 150,
          child: TextField(
            onSubmitted: (value) async {
              await authenticate(context, ref);
            },
            decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8)),
            obscureText: true,
            controller: passwordController,
          ),
        ),
      ],
    );
  }

  Future<void> authenticate(BuildContext context, WidgetRef ref) async {
    EasyLoading.show();

    String username = usernameController.text.trim();
    String passwordHash = hashPassword(passwordController.text.trim());

    User? user;

    try {
      String? ip = connectionSettingsBox.get('ip');
      String? databaseName = connectionSettingsBox.get('databaseName');
      String? dbUsername = connectionSettingsBox.get('username');
      String? password = connectionSettingsBox.get('password');
      int? port = connectionSettingsBox.get('port');

      if (ip == null || databaseName == null || dbUsername == null || password == null || port == null) {
        return await Future.error('Error in connecting to database. Please check connection settings');
      }

      globalConnectionSettings = ConnectionSettings(
        ip: ip,
        databaseName: databaseName,
        port: port,
        username: dbUsername,
        password: password,
      );

      user = await DatabaseAPI.authenticateUser(ref, username, passwordHash);
    } catch (e, st) {
      return showErrorAndStacktrace(e, st);
    }

    ref.read(userProvider.notifier).state = user;

    ref.read(sidebarControllerProvider.notifier).state = SidebarXController(selectedIndex: 0);

    await EasyLoading.dismiss();
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacementNamed(context, 'home');
  }
}
