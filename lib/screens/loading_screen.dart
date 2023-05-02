import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var settings = ConnectionSettings(
          host: 'localhost',
          port: 3306,
          user: 'root',
          password: 'root',
          db: 'eon');
      try {
        MySqlConnection conn = await MySqlConnection.connect(settings);

        ref.read(sqlConnProvider.notifier).state = conn;

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ),
        );
      } catch (e) {
        debugPrint('error hatdog');
      }
    });

    return const CircularProgressIndicator();
  }
}
