import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_radius.dart';
import 'package:twine/core/theme/twine_shadows.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

/// A Twine-styled card container.
///
/// Has a subtle shadow, large border radius, and optional gradient / onTap.
class TwineCard extends StatelessWidget {
  const TwineCard({
    super.key,
    required this.child,
    this.onTap,
    this.gradient,
    this.padding,
    this.color,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        color ?? (isDark ? TwineColors.darkCard : TwineColors.white);
    final effectiveRadius = borderRadius ?? TwineRadius.allLg;

    Widget card = Container(
      padding: padding ?? TwineSpacing.allLg,
      decoration: BoxDecoration(
        color: gradient == null ? effectiveColor : null,
        gradient: gradient,
        borderRadius: effectiveRadius,
        boxShadow: isDark ? null : TwineShadows.sm,
      ),
      child: child,
    );

    if (onTap != null) {
      card = TapScale(onTap: onTap, child: card);
    }

    return card;
  }
}
