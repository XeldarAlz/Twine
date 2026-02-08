import 'package:flutter/material.dart';

/// Twine color tokens.
///
/// All colors from the Twine design system, organized by category.
class TwineColors {
  TwineColors._();

  // ─── Primary ───────────────────────────────────────────────
  static const Color twineRose = Color(0xFFE85A71);
  static const Color coral = Color(0xFFFF8A5B);
  static const Color blush = Color(0xFFFFB8C6);

  /// Primary gradient (Twine Rose → Coral).
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [twineRose, coral],
  );

  // ─── Neutrals ──────────────────────────────────────────────
  static const Color charcoal = Color(0xFF1A1A2E);
  static const Color slate = Color(0xFF4A4A68);
  static const Color gray = Color(0xFF9A9AB0);
  static const Color silver = Color(0xFFD1D1DB);
  static const Color snow = Color(0xFFF8F8FC);
  static const Color white = Color(0xFFFFFFFF);

  // ─── Semantic ──────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);

  // ─── Mood ──────────────────────────────────────────────────
  static const Color moodHappy = Color(0xFFFFC107);
  static const Color moodLoved = Color(0xFFE85A71);
  static const Color moodSad = Color(0xFF78909C);
  static const Color moodTired = Color(0xFF80DEEA);
  static const Color moodStressed = Color(0xFFFF8A65);
  static const Color moodGrateful = Color(0xFF81C784);

  // ─── Accent Options (user-selectable) ──────────────────────
  static const List<Color> accentOptions = [
    twineRose, // default
    Color(0xFF26A69A), // Teal
    Color(0xFFFF7043), // Deep Orange
    Color(0xFFFFCA28), // Amber
    Color(0xFF66BB6A), // Green
    Color(0xFF7E57C2), // Purple
  ];

  // ─── Dark Mode ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D0D1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF252540);
}
