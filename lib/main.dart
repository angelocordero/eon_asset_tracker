// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'eon_asset_tracker.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EonAssetTracker(),
    ),
  );
}
