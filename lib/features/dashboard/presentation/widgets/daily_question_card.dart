import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/heartbeat_animation.dart';
import 'package:twine/shared/widgets/buttons/twine_button.dart';
import 'package:twine/shared/widgets/cards/twine_card.dart';

import '../../domain/dashboard_state.dart';

class DailyQuestionCard extends StatelessWidget {
  const DailyQuestionCard({
    super.key,
    required this.question,
    required this.questionState,
    this.onTap,
  });

  final DailyQuestion? question;
  final QuestionState questionState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (question == null) return const SizedBox.shrink();

    return TwineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 18,
                color: TwineColors.info,
              ),
              const SizedBox(width: TwineSpacing.sm),
              Text(
                "Today's Question",
                style: TwineTypography.bodySm.copyWith(
                  color: TwineColors.gray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Category chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: question!.category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question!.category.label,
                  style: TwineTypography.caption.copyWith(
                    color: question!.category.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TwineSpacing.md),

          // Question text
          Text(
            question!.questionText,
            style: TwineTypography.bodyLg.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TwineSpacing.lg),

          // State-dependent CTA
          _buildCta(context),
        ],
      ),
    );
  }

  Widget _buildCta(BuildContext context) {
    return switch (questionState) {
      QuestionState.unanswered => SizedBox(
          width: double.infinity,
          child: TwineButton.primary(
            label: 'Answer',
            onPressed: onTap,
          ),
        ),
      QuestionState.waitingForPartner => Center(
          child: PulseAnimation(
            child: Text(
              'Waiting for partner...',
              style: TwineTypography.bodyMd.copyWith(
                color: TwineColors.gray,
              ),
            ),
          ),
        ),
      QuestionState.bothAnswered => SizedBox(
          width: double.infinity,
          child: TwineButton.secondary(
            label: 'Reveal Answers',
            onPressed: onTap,
          ),
        ),
    };
  }
}
