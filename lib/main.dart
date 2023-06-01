// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'core/constants.dart';
import 'eon_asset_tracker.dart';

void main() async {
  Hive.init(await getApplicationSupportDirectory().then((value) => value.path));

  await Hive.openBox('settings', encryptionCipher: HiveAesCipher(secureKey));

  runApp(
    const ProviderScope(
      child: EonAssetTracker(),
    ),
  );
}
