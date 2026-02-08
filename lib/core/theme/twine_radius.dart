import 'package:flutter/material.dart';

/// Twine border radius tokens.
class TwineRadius {
  TwineRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  // ─── BorderRadius helpers ─────────────────────────────────
  static const BorderRadius allXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius allSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius allMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius allLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius allXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius allFull = BorderRadius.all(Radius.circular(full));

  static const BorderRadius topSm = BorderRadius.vertical(
    top: Radius.circular(sm),
  );
  static const BorderRadius topMd = BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static const BorderRadius topLg = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
  static const BorderRadius topXl = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}
