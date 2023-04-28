import 'package:eon_asset_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

class EonAssetTracker extends StatelessWidget {
  const EonAssetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
