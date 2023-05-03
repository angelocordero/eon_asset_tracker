import 'package:eon_asset_tracker/core/constants.dart';
import 'package:eon_asset_tracker/screens/loading_screen.dart';
import 'package:flutter/material.dart';

class EonAssetTracker extends StatelessWidget {
  const EonAssetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const LoadingScreen(),
    );
  }
}
