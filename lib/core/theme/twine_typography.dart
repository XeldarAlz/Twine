import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Twine typography tokens.
///
/// Uses Outfit via google_fonts. All styles are `static final` because
/// google_fonts returns non-const TextStyles.
class TwineTypography {
  TwineTypography._();

  static String get _fontFamily => GoogleFonts.outfit().fontFamily!;

  // ─── Display ───────────────────────────────────────────────
  static final TextStyle displayLg = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static final TextStyle displayMd = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static final TextStyle displaySm = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ─── Heading ───────────────────────────────────────────────
  static final TextStyle headingLg = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final TextStyle headingMd = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final TextStyle headingSm = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ─── Body ──────────────────────────────────────────────────
  static final TextStyle bodyLg = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyMd = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodySm = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ─── Caption / Overline ────────────────────────────────────
  static final TextStyle caption = GoogleFonts.outfit(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static final TextStyle overline = GoogleFonts.outfit(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.2,
  );

  /// Build a Material [TextTheme] from Twine tokens.
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLg,
        displayMedium: displayMd,
        displaySmall: displaySm,
        headlineLarge: headingLg,
        headlineMedium: headingMd,
        headlineSmall: headingSm,
        titleLarge: headingLg,
        titleMedium: headingMd,
        titleSmall: headingSm,
        bodyLarge: bodyLg,
        bodyMedium: bodyMd,
        bodySmall: bodySm,
        labelLarge: bodyMd.copyWith(fontWeight: FontWeight.w600),
        labelMedium: caption,
        labelSmall: overline,
      );

  /// Font family string for ThemeData.
  static String get fontFamily => _fontFamily;
}
