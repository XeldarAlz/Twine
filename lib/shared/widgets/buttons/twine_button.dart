import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_radius.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

enum _ButtonVariant { primary, secondary, text }

/// Twine's primary button widget.
///
/// Use the named constructors for the three variants:
/// - [TwineButton.primary] — gradient fill (default CTA)
/// - [TwineButton.secondary] — outlined
/// - [TwineButton.text] — minimal / text-only
class TwineButton extends StatelessWidget {
  const TwineButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enabled = true,
  }) : _variant = _ButtonVariant.primary;

  const TwineButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enabled = true,
  }) : _variant = _ButtonVariant.secondary;

  const TwineButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  })  : _variant = _ButtonVariant.text,
        isFullWidth = false;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool enabled;
  final _ButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && !isLoading && onPressed != null;

    Widget child = _buildContent(context);

    if (isFullWidth) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return TapScale(
      onTap: isActive ? onPressed : null,
      enabled: isActive,
      child: child,
    );
  }

  Widget _buildContent(BuildContext context) {
    final labelStyle =
        TwineTypography.bodyLg.copyWith(fontWeight: FontWeight.w600);

    final inner = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _variant == _ButtonVariant.primary
                  ? TwineColors.white
                  : TwineColors.twineRose,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    switch (_variant) {
      case _ButtonVariant.primary:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: enabled ? TwineColors.primaryGradient : null,
            color: enabled ? null : TwineColors.silver,
            borderRadius: TwineRadius.allMd,
          ),
          alignment: Alignment.center,
          child: DefaultTextStyle.merge(
            style: labelStyle.copyWith(color: TwineColors.white),
            child: IconTheme(
              data: const IconThemeData(color: TwineColors.white, size: 20),
              child: inner,
            ),
          ),
        );

      case _ButtonVariant.secondary:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: enabled ? TwineColors.twineRose : TwineColors.silver,
            ),
            borderRadius: TwineRadius.allMd,
          ),
          alignment: Alignment.center,
          child: DefaultTextStyle.merge(
            style: labelStyle.copyWith(
              color: enabled ? TwineColors.twineRose : TwineColors.gray,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: enabled ? TwineColors.twineRose : TwineColors.gray,
                size: 20,
              ),
              child: inner,
            ),
          ),
        );

      case _ButtonVariant.text:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DefaultTextStyle.merge(
            style: labelStyle.copyWith(
              color: enabled ? TwineColors.twineRose : TwineColors.gray,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: enabled ? TwineColors.twineRose : TwineColors.gray,
                size: 20,
              ),
              child: inner,
            ),
          ),
        );
    }
  }
}
