import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_radius.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

import '../../domain/dashboard_state.dart';

class MoodPickerSheet extends StatelessWidget {
  const MoodPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? TwineColors.darkSurface : TwineColors.white,
        borderRadius: TwineRadius.topXl,
      ),
      padding: EdgeInsets.only(
        left: TwineSpacing.xl,
        right: TwineSpacing.xl,
        top: TwineSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + TwineSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TwineColors.silver,
              borderRadius: TwineRadius.allFull,
            ),
          ),
          const SizedBox(height: TwineSpacing.xl),

          // Title
          Text(
            'How are you feeling?',
            style: TwineTypography.headingMd.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: TwineSpacing.xl),

          // 4x2 Grid of moods
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: TwineSpacing.lg,
            crossAxisSpacing: TwineSpacing.lg,
            children: MoodType.values.map((mood) {
              return _MoodOption(
                mood: mood,
                onTap: () {
                  TwineHaptics.moodChanged();
                  Navigator.pop(context, mood);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  const _MoodOption({required this.mood, required this.onTap});

  final MoodType mood;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mood.color.withValues(alpha: 0.12),
            ),
            alignment: Alignment.center,
            child: Text(
              mood.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: TwineSpacing.xs),
          Text(
            mood.label,
            style: TwineTypography.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
