import 'package:eon_asset_tracker/notifiers/theme_notifier.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class EonAssetTracker extends ConsumerWidget {
  const EonAssetTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..textColor = Colors.white
      ..backgroundColor = Colors.black54
      ..indicatorColor = Colors.blue;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: ThemeData.light().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
          ),
        ),
      ),
      themeMode: ref.watch(themeNotifierProvider).valueOrNull ?? ThemeMode.light,
      home: const LoginScreen(),
      builder: EasyLoading.init(),
      routes: {
        'login': (context) => const LoginScreen(),
        'home': (context) => const HomeScreen(),
      },
    );
  }
}
