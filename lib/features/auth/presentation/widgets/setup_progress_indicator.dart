import 'package:flutter/material.dart';

import 'package:twine/core/theme/motion_tokens.dart';
import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/animated_widgets.dart';

/// 3-step progress indicator with circles and connecting lines.
class SetupProgressIndicator extends StatelessWidget {
  const SetupProgressIndicator({
    super.key,
    required this.currentStep,
    this.labels = const ['Name', 'Photo', 'Dates'],
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < labels.length; i++) ...[
          if (i > 0) _buildLine(i <= currentStep),
          _buildStep(context, i),
        ],
      ],
    );
  }

  Widget _buildStep(BuildContext context, int index) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: TwineDurations.normal,
          curve: TwineCurves.tender,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? TwineColors.twineRose
                : isCurrent
                    ? TwineColors.blush
                    : TwineColors.silver.withAlpha(77),
            border: isCurrent
                ? Border.all(color: TwineColors.twineRose, width: 2)
                : null,
          ),
          child: Center(
            child: isCompleted
                ? AnimatedCheckmark(
                    size: 16,
                    color: TwineColors.white,
                    strokeWidth: 2,
                  )
                : Text(
                    '${index + 1}',
                    style: TwineTypography.bodySm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCurrent
                          ? TwineColors.twineRose
                          : TwineColors.gray,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          labels[index],
          style: TwineTypography.caption.copyWith(
            color: isCurrent || isCompleted
                ? TwineColors.twineRose
                : TwineColors.gray,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool active) {
    return AnimatedContainer(
      duration: TwineDurations.normal,
      curve: TwineCurves.tender,
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: active ? TwineColors.twineRose : TwineColors.silver.withAlpha(77),
    );
  }
}
