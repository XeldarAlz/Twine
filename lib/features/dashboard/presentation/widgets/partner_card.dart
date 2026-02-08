import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/utils/extensions.dart';
import 'package:twine/core/widgets/animated/heartbeat_animation.dart';
import 'package:twine/core/widgets/animated/stagger_animation.dart';
import 'package:twine/shared/widgets/cards/twine_card.dart';
import 'package:twine/shared/widgets/display/twine_avatar.dart';

import '../../domain/dashboard_state.dart';

class PartnerCard extends StatelessWidget {
  const PartnerCard({
    super.key,
    required this.data,
    this.onTap,
  });

  final DashboardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TwineCard(
      onTap: onTap,
      gradient: isDark
          ? null
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TwineColors.blush.withValues(alpha: 0.15),
                TwineColors.white,
              ],
            ),
      child: Column(
        children: [
          // Avatar with heartbeat
          HeartbeatAnimation.subtle(
            animate: data.isPartnerOnline,
            child: TwineAvatar(
              imageUrl: data.partnerAvatarUrl,
              name: data.partnerName,
              size: TwineAvatarSize.large,
              showOnlineIndicator: true,
              isOnline: data.isPartnerOnline,
            ),
          ),
          const SizedBox(height: TwineSpacing.md),

          // Partner name + nickname
          Text(
            data.partnerName,
            style: TwineTypography.headingMd.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (data.partnerNickname != null) ...[
            const SizedBox(height: 2),
            Text(
              '"${data.partnerNickname}"',
              style: TwineTypography.bodySm.copyWith(
                color: TwineColors.gray,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],

          // Mood pill
          if (data.partnerMood != null) ...[
            const SizedBox(height: TwineSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: data.partnerMood!.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.partnerMood!.emoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    data.partnerMood!.label,
                    style: TwineTypography.bodySm.copyWith(
                      color: data.partnerMood!.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Last seen (if offline)
          if (!data.isPartnerOnline && data.partnerLastSeen != null) ...[
            const SizedBox(height: TwineSpacing.xs),
            Text(
              'Last seen ${data.partnerLastSeen!.relativeTime}',
              style: TwineTypography.bodySm.copyWith(
                color: TwineColors.gray,
              ),
            ),
          ],

          const SizedBox(height: TwineSpacing.lg),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatItem(
                value: data.daysTogether,
                label: 'days together',
              ),
              Container(
                width: 1,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: TwineSpacing.lg),
                color: TwineColors.silver.withValues(alpha: 0.5),
              ),
              _StatItem(
                value: data.streakCount,
                label: 'day streak',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedCounter(
          value: value,
          style: TwineTypography.headingMd.copyWith(
            color: TwineColors.twineRose,
          ),
        ),
        Text(
          label,
          style: TwineTypography.bodySm.copyWith(
            color: TwineColors.gray,
          ),
        ),
      ],
    );
  }
}
