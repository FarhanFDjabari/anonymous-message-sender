import 'package:flutter/material.dart';

/// Session-only theme mode controller.
/// Default is ThemeMode.system; can be cycled through light → dark → system.
final themeController = ThemeController();

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.system);

  /// Cycle through ThemeMode: system → light → dark → system → ...
  void toggle() {
    value = switch (value) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }
}
