import 'package:anonymous_send_wa/providers/theme_controller.dart';
import 'package:anonymous_send_wa/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeController', () {
    test('defaults to ThemeMode.system', () {
      final controller = ThemeController();
      expect(controller.value, ThemeMode.system);
    });

    test('cycles through theme modes: system → light → dark → system', () {
      final controller = ThemeController();

      controller.toggle();
      expect(controller.value, ThemeMode.light);

      controller.toggle();
      expect(controller.value, ThemeMode.dark);

      controller.toggle();
      expect(controller.value, ThemeMode.system);

      controller.toggle();
      expect(controller.value, ThemeMode.light);
    });

    testWidgets('notifies listeners when toggled', (tester) async {
      final controller = ThemeController();
      int callCount = 0;

      controller.addListener(() => callCount++);
      controller.toggle();
      expect(callCount, 1);

      controller.toggle();
      expect(callCount, 2);
    });
  });

  group('AppTheme', () {
    testWidgets('light theme uses light colors', (tester) async {
      final lightTheme = AppTheme.light();
      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.scaffoldBackgroundColor, const Color(0xFFFFFFFF));
    });

    testWidgets('dark theme uses dark colors', (tester) async {
      final darkTheme = AppTheme.dark();
      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.scaffoldBackgroundColor, const Color(0xFF111827));
    });

    testWidgets('light theme applies to MaterialApp', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: Center(
              child: Text('Light Theme'),
            ),
          ),
        ),
      );

      expect(find.text('Light Theme'), findsOneWidget);
    });

    testWidgets('dark theme applies to MaterialApp', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.dark,
          home: const Scaffold(
            body: Center(
              child: Text('Dark Theme'),
            ),
          ),
        ),
      );

      expect(find.text('Dark Theme'), findsOneWidget);
    });
  });
}
