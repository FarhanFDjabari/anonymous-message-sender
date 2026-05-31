import 'package:anonymous_send_wa/providers/theme_controller.dart';
import 'package:anonymous_send_wa/theme/app_theme.dart';
import 'package:anonymous_send_wa/view/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'QuickSend',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}
