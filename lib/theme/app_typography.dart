import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme buildTextTheme(Brightness brightness) {
    final base =
        brightness == Brightness.light ? ThemeData.light() : ThemeData.dark();

    return GoogleFonts.interTextTheme(base.textTheme)
        .copyWith(
          displayLarge: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.displayLarge,
          ),
          displayMedium: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.displayMedium,
          ),
          displaySmall: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.displaySmall,
          ),
          headlineLarge: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.headlineLarge,
          ),
          headlineMedium: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.headlineMedium,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.headlineSmall,
          ),
          titleLarge: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.titleLarge,
          ),
          titleMedium: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.titleMedium,
          ),
          titleSmall: GoogleFonts.plusJakartaSans(
            textStyle: base.textTheme.titleSmall,
          ),
        )
        .apply(
          displayColor: brightness == Brightness.light
              ? const Color(0xFF1A202C)
              : const Color(0xFFF7FAFC),
          bodyColor: brightness == Brightness.light
              ? const Color(0xFF2D3748)
              : const Color(0xFFE2E8F0),
        );
  }
}
