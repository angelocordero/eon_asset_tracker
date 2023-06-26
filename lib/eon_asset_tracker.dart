import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/constants.dart';
import 'notifiers/theme_notifier.dart';
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
      builder: EasyLoading.init(
        builder: ((context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 1280, name: '720p'),
              const Breakpoint(start: 1281, end: double.infinity, name: '1080p'),
            ],
          );
        }),
      ),
      initialRoute: 'login',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          return MaxWidthBox(
            maxWidth: 1920,
            child: ResponsiveScaledBox(
              width: ResponsiveValue<double>(
                context,
                conditionalValues: [
                  Condition.equals(name: '720p', value: 1280),
                  Condition.equals(name: '1080p', value: 1920),
                ],
              ).value,
              child: BouncingScrollWrapper.builder(
                  context,
                  buildPage(
                    settings.name ?? '',
                  ),
                  dragWithMouse: true),
            ),
          );
        });
      },
      // routes: {
      //   'login': (context) => const LoginScreen(),
      //   'home': (context) => const HomeScreen(),
      // },
    );
  }

  Widget buildPage(String name) {
    switch (name) {
      case 'login':
        return const LoginScreen();
      case 'home':
        return const HomeScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
