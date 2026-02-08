import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    required this.onSendTap,
    required this.onSharePhoto,
    required this.onDailyQuestion,
  });

  final VoidCallback onSendTap;
  final VoidCallback onSharePhoto;
  final VoidCallback onDailyQuestion;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickAction(
          icon: Icons.favorite,
          label: 'Send Tap',
          color: TwineColors.twineRose,
          onTap: onSendTap,
        ),
        _QuickAction(
          icon: Icons.photo_camera,
          label: 'Photo',
          color: TwineColors.coral,
          onTap: onSharePhoto,
        ),
        _QuickAction(
          icon: Icons.chat_bubble_outline,
          label: 'Question',
          color: TwineColors.info,
          onTap: onDailyQuestion,
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: () {
        TwineHaptics.light();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: TwineSpacing.sm),
          Text(
            label,
            style: TwineTypography.bodySm.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
