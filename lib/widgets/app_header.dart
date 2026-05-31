import 'package:anonymous_send_wa/components/adaptive_text.dart';
import 'package:anonymous_send_wa/components/entrance_fader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EntranceFader(
      duration: const Duration(milliseconds: 300),
      offset: const Offset(0, -8),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.send_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'QuickSend',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFF7FAFC) : const Color(0xFF1A202C),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          AdaptiveText(
            'Send WhatsApp Messages to Any Number',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
