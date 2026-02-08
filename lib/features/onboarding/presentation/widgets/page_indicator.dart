import 'package:flutter/material.dart';

import 'package:twine/core/theme/motion_tokens.dart';
import 'package:twine/core/theme/twine_colors.dart';

/// Animated dot indicator for PageView.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.count,
    required this.currentPage,
  });

  final int count;
  final double currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final distance = (currentPage - index).abs();
        final isActive = distance < 0.5;

        return AnimatedContainer(
          duration: TwineDurations.fast,
          curve: TwineCurves.easeOutSoft,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? TwineColors.twineRose
                : TwineColors.silver,
          ),
        );
      }),
    );
  }
}
