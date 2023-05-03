import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import 'home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static final TextEditingController usernameController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MySqlConnection? conn = ref.watch(sqlConnProvider);

    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('User Login'),
                const SizedBox(
                  height: 20,
                ),
                usernameField(),
                const SizedBox(
                  height: 20,
                ),
                passwordField(context, conn),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await authenticate(context, conn);
                    },
                    child: const Text('Login')),
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
            controller: usernameController,
            decoration: const InputDecoration(
                isDense: true, contentPadding: EdgeInsets.all(8)),
          ),
        ),
      ],
    );
  }

  Widget passwordField(BuildContext context, MySqlConnection? conn) {
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
              await authenticate(context, conn);
            },
            decoration: const InputDecoration(
                isDense: true, contentPadding: EdgeInsets.all(8)),
            obscureText: true,
            controller: passwordController,
          ),
        ),
      ],
    );
  }

  Future<void> authenticate(BuildContext context, MySqlConnection? conn) async {
    String username = usernameController.text.trim();
    String passwordHash = hashPassword(passwordController.text.trim());

    if (conn == null) {
      debugPrint('connection to database failed');
      return;
    }

    bool? authenticated = await authenticateUser(username, passwordHash, conn);

    if (authenticated == null) {
      debugPrint('authentication failed');
      return;
    }

    if (authenticated == false) {
      debugPrint('user does not exist');
      return;
    }
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const HomeScreen();
        },
      ),
    );
  }
}
