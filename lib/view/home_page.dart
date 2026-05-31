import 'package:anonymous_send_wa/providers/theme_controller.dart';
import 'package:anonymous_send_wa/view/message_form.dart';
import 'package:anonymous_send_wa/widgets/app_footer.dart';
import 'package:anonymous_send_wa/widgets/app_header.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController,
            builder: (context, mode, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: IconButton(
                    onPressed: themeController.toggle,
                    icon: switch (mode) {
                      ThemeMode.system => const Icon(Icons.brightness_auto),
                      ThemeMode.light => const Icon(Icons.light_mode),
                      ThemeMode.dark => const Icon(Icons.dark_mode),
                    },
                    tooltip: 'Toggle theme',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 24,
                      children: const [
                        AppHeader(),
                        MessageForm(),
                        AppFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
