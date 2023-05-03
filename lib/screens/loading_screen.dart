import 'package:eon_asset_tracker/core/providers.dart';
import 'package:eon_asset_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import '../core/database_api.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var settings = ConnectionSettings(
          host: '127.0.0.1',
          port: 3306,
          user: 'root',
          password: 'root',
          db: 'eon');
      try {
        MySqlConnection conn = await MySqlConnection.connect(settings);

        ref.read(sqlConnProvider.notifier).state = conn;

        await Future.delayed(const Duration(seconds: 1));

        ref.read(departmentsProvider.notifier).state =
            await DatabaseAPI.getDepartments(conn);

        ref.read(categoriesProvider.notifier).state =
            await DatabaseAPI.getCategories(conn);

        ref.read(inventoryProvider.notifier).init(
            conn, ref.read(departmentsProvider), ref.read(categoriesProvider));

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

    return const Center(child: CircularProgressIndicator());
  }
}