import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';
import 'package:twine/shared/widgets/cards/twine_card.dart';

import '../../domain/dashboard_state.dart';

class MoodSection extends StatelessWidget {
  const MoodSection({
    super.key,
    required this.currentMood,
    required this.onSetMood,
  });

  final MoodType? currentMood;
  final VoidCallback onSetMood;

  @override
  Widget build(BuildContext context) {
    return TwineCard(
      child: currentMood == null ? _buildPrompt(context) : _buildMood(context),
    );
  }

  Widget _buildPrompt(BuildContext context) {
    return TapScale(
      onTap: onSetMood,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TwineColors.twineRose.withValues(alpha: 0.12),
            ),
            child: const Icon(
              Icons.emoji_emotions_outlined,
              color: TwineColors.twineRose,
              size: 20,
            ),
          ),
          const SizedBox(width: TwineSpacing.md),
          Expanded(
            child: Text(
              'How are you feeling?',
              style: TwineTypography.bodyLg.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: TwineColors.gray,
          ),
        ],
      ),
    );
  }

  Widget _buildMood(BuildContext context) {
    return Row(
      children: [
        Text(
          currentMood!.emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(width: TwineSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your mood',
                style: TwineTypography.bodySm.copyWith(
                  color: TwineColors.gray,
                ),
              ),
              Text(
                currentMood!.label,
                style: TwineTypography.bodyLg.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        TapScale(
          onTap: onSetMood,
          child: Text(
            'Change',
            style: TwineTypography.bodySm.copyWith(
              color: TwineColors.twineRose,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
