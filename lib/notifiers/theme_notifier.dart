import 'package:flutter/material.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  FutureOr<ThemeMode> build() async {
    ThemeMode themeMode = ThemeMode.light;
    try {
      themeMode = ThemeMode.values.byName(await themeSettingsBox.get('themeMode'));
    } catch (e) {
      //
    }

    return themeMode;
  }

  toggleTheme() async {
    if (state.value == ThemeMode.light) {
      state = const AsyncValue<ThemeMode>.data(ThemeMode.dark);
    } else {
      state = const AsyncValue<ThemeMode>.data(ThemeMode.light);
    }

    themeSettingsBox.put('themeMode', state.value?.name);
  }
}
