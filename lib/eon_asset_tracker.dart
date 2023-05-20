// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sidebarx/sidebarx.dart';

// Project imports:
import 'core/constants.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class EonAssetTracker extends StatelessWidget {
  const EonAssetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..textColor = Colors.white
      ..backgroundColor = Colors.black54
      ..indicatorColor = Colors.blue;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
      builder: EasyLoading.init(),
      routes: {
        'login': (context) => const LoginScreen(),
        'home': (context) => HomeScreen(
              controller: SidebarXController(
                selectedIndex: 0,
              ),
            ),
      },
    );
  }
}
