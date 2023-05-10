import 'package:eon_asset_tracker/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import '../core/database_api.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        var settings = ConnectionSettings(host: '127.0.0.1', port: 3306, user: 'root', password: 'root', db: 'eon');
        try {
          MySqlConnection conn = await MySqlConnection.connect(settings);

          ref.read(sqlConnProvider.notifier).state = conn;

          await Future.delayed(const Duration(seconds: 1));

          ref.read(departmentsProvider.notifier).state = await DatabaseAPI.getDepartments(conn);

          ref.read(categoriesProvider.notifier).state = await DatabaseAPI.getCategories(conn);

          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, 'login');
        } catch (e) {
          debugPrint(e.toString());
          EasyLoading.showError(e.toString());
        }
      },
    );

    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading'),
          SizedBox(
            width: 50,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
