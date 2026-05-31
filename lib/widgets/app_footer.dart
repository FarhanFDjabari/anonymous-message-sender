import 'package:anonymous_send_wa/components/adaptive_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: AdaptiveText(
        'Open WhatsApp chats without saving the contact',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
