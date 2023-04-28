import 'package:eon_asset_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  static late MySqlConnection conn;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var settings = ConnectionSettings(
          host: 'localhost',
          port: 3306,
          user: 'root',
          password: 'root',
          db: 'eon');
      try {
        conn = await MySqlConnection.connect(settings);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen(conn: conn);
            },
          ),
        );
      } catch (e) {
        print('error hatdog');
      }
    });

    return const CircularProgressIndicator();
  }
}
