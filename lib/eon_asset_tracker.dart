import 'package:eon_asset_tracker/core/custom_route.dart';
import 'package:eon_asset_tracker/inventory_advanced_search/search_popup.dart';
import 'package:eon_asset_tracker/inventory_advanced_search/slide_route.dart';
import 'package:eon_asset_tracker/screens/add_item_screen.dart';
import 'package:eon_asset_tracker/screens/connection_settings_screen.dart';
import 'package:eon_asset_tracker/screens/edit_item_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/constants.dart';
import 'models/connection_settings_model.dart';
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
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: defaultBorderRadius,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
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
              const Breakpoint(start: 0, end: 1200, name: '720p'),
              const Breakpoint(start: 1201, end: double.infinity, name: '1080p'),
            ],
          );
        }),
      ),
      initialRoute: 'login',
      onGenerateRoute: (RouteSettings settings) {
        return switch (settings.name) {
          'login' => MaterialPageRoute(
              builder: (context) {
                return _buildPage(
                  context,
                  const LoginScreen(),
                );
              },
            ),
          'home' => MaterialPageRoute(
              builder: (context) => _buildPage(
                context,
                const HomeScreen(),
              ),
            ),
          'search' => SlideRoute(
              builder: (context) => _buildPage(
                context,
                const SearchPopup(),
              ),
            ),
          'add_item' => CustomRoute(
              builder: (context) => _buildPage(
                context,
                const AddItemScreen(),
              ),
            ),
          'edit_item' => CustomRoute(
              builder: (context) => _buildPage(
                context,
                const EditItemScreen(),
              ),
            ),
          'connection_settings' => CustomRoute(builder: (context) {
              ConnectionSettings connectionSettings;

              try {
                connectionSettings = ConnectionSettings(
                  databaseName: connectionSettingsBox.get('databaseName'),
                  ip: connectionSettingsBox.get('ip'),
                  port: connectionSettingsBox.get('port'),
                  username: connectionSettingsBox.get('username'),
                  password: connectionSettingsBox.get('password'),
                );
              } catch (e) {
                connectionSettings = ConnectionSettings.empty();
              }

              return _buildPage(
                context,
                ConnectionSettingsScreen(
                  localIPController: TextEditingController.fromValue(
                    TextEditingValue(text: connectionSettings.ip),
                  ),
                  portController: TextEditingController.fromValue(
                    TextEditingValue(text: connectionSettings.port.toString()),
                  ),
                  userController: TextEditingController.fromValue(
                    TextEditingValue(text: connectionSettings.username),
                  ),
                  passwordController: TextEditingController.fromValue(
                    TextEditingValue(text: connectionSettings.password),
                  ),
                  dbNameController: TextEditingController.fromValue(
                    TextEditingValue(text: connectionSettings.databaseName),
                  ),
                ),
              );
            }),
          _ => MaterialPageRoute(
              builder: (context) => _buildPage(
                context,
                const SizedBox.shrink(),
              ),
            ),
        };
      },
    );
  }

  Widget _buildPage(BuildContext context, Widget child) {
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
        child: ClampingScrollWrapper.builder(
          context,
          child,
          dragWithMouse: false,
        ),
      ),
    );
  }
}
