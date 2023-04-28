import 'package:eon_asset_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class EonAssetTracker extends StatelessWidget {
  const EonAssetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    var settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: 'root',
        db: 'eon');
    var conn = MySqlConnection.connect(settings);

    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}
