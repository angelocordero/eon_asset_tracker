import 'package:eon_asset_tracker/eon_asset_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EonAssetTracker(),
    ),
  );
}
