import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants.dart';
import 'eon_asset_tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init(await getApplicationSupportDirectory().then((value) => value.path));
  await Hive.openBox('settings', encryptionCipher: HiveAesCipher(secureKey));

  runApp(
    const ProviderScope(
      child: EonAssetTracker(),
    ),
  );
}
