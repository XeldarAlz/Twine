import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/stagger_animation.dart';

/// A single onboarding page layout.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.animate = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TwineSpacing.screenPadding,
      child: StaggeredColumn(
        staggerDelay: const Duration(milliseconds: 50),
        duration: const Duration(milliseconds: 300),
        animation: StaggerAnimation.fadeSlideUp,
        animate: animate,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: TwineColors.primaryGradient,
            ),
            child: Icon(
              icon,
              size: 48,
              color: TwineColors.white,
            ),
          ),
          const SizedBox(height: TwineSpacing.xxl),
          Text(
            title,
            style: TwineTypography.displaySm.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TwineSpacing.md),
          Text(
            subtitle,
            style: TwineTypography.bodyLg.copyWith(
              color: TwineColors.slate,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
