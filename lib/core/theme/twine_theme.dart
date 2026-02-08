import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'twine_colors.dart';
import 'twine_radius.dart';
import 'twine_typography.dart';

/// Builds [ThemeData] for Twine in light and dark variants.
class TwineTheme {
  TwineTheme._();

  // ─── Light Theme ───────────────────────────────────────────
  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: TwineColors.twineRose,
      onPrimary: TwineColors.white,
      primaryContainer: TwineColors.blush,
      onPrimaryContainer: TwineColors.charcoal,
      secondary: TwineColors.coral,
      onSecondary: TwineColors.white,
      secondaryContainer: TwineColors.blush.withValues(alpha: 0.3),
      onSecondaryContainer: TwineColors.charcoal,
      error: TwineColors.error,
      onError: TwineColors.white,
      surface: TwineColors.white,
      onSurface: TwineColors.charcoal,
      surfaceContainerHighest: TwineColors.snow,
      onSurfaceVariant: TwineColors.slate,
      outline: TwineColors.silver,
      outlineVariant: TwineColors.silver.withValues(alpha: 0.5),
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  // ─── Dark Theme ────────────────────────────────────────────
  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: TwineColors.twineRose,
      onPrimary: TwineColors.white,
      primaryContainer: TwineColors.twineRose.withValues(alpha: 0.2),
      onPrimaryContainer: TwineColors.blush,
      secondary: TwineColors.coral,
      onSecondary: TwineColors.white,
      secondaryContainer: TwineColors.coral.withValues(alpha: 0.2),
      onSecondaryContainer: TwineColors.blush,
      error: TwineColors.error,
      onError: TwineColors.white,
      surface: TwineColors.darkSurface,
      onSurface: TwineColors.snow,
      surfaceContainerHighest: TwineColors.darkCard,
      onSurfaceVariant: TwineColors.gray,
      outline: TwineColors.slate,
      outlineVariant: TwineColors.slate.withValues(alpha: 0.5),
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ─── Shared Builder ────────────────────────────────────────
  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textTheme = TwineTypography.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: TwineTypography.fontFamily,
      scaffoldBackgroundColor:
          isDark ? TwineColors.darkBackground : TwineColors.snow,

      // ─── AppBar ────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        titleTextStyle: TwineTypography.headingMd.copyWith(
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // ─── Card ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? TwineColors.darkCard : TwineColors.white,
        shape: RoundedRectangleBorder(borderRadius: TwineRadius.allLg),
        margin: EdgeInsets.zero,
      ),

      // ─── Input ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? TwineColors.darkCard : TwineColors.snow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: TwineRadius.allMd,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: TwineRadius.allMd,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: TwineRadius.allMd,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: TwineRadius.allMd,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: TwineRadius.allMd,
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        hintStyle: TwineTypography.bodyMd.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: TwineTypography.bodySm.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: TwineTypography.bodySm.copyWith(
          color: colorScheme.error,
        ),
      ),

      // ─── Elevated Button ───────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: TwineRadius.allMd),
          textStyle:
              TwineTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ─── Outlined Button ───────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: TwineRadius.allMd),
          textStyle:
              TwineTypography.bodyLg.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ─── Text Button ──────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle:
              TwineTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ─── Bottom Navigation ─────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? TwineColors.darkSurface : TwineColors.white,
        selectedItemColor: TwineColors.twineRose,
        unselectedItemColor: TwineColors.gray,
        selectedLabelStyle: TwineTypography.caption,
        unselectedLabelStyle: TwineTypography.caption,
        elevation: 0,
      ),

      // ─── NavigationBar (Material 3) ────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? TwineColors.darkSurface : TwineColors.white,
        indicatorColor: TwineColors.twineRose.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TwineTypography.caption.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),

      // ─── Divider ──────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // ─── SnackBar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: TwineColors.charcoal,
        contentTextStyle: TwineTypography.bodyMd.copyWith(
          color: TwineColors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: TwineRadius.allMd),
      ),
    );
  }
}
