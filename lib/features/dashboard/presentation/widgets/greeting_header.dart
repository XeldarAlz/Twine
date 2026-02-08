import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.userName,
    this.onSettingsTap,
  });

  final String userName;
  final VoidCallback? onSettingsTap;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: TwineTypography.bodySm.copyWith(
                  color: TwineColors.gray,
                ),
              ),
              Text(
                userName,
                style: TwineTypography.headingLg.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        TapScale(
          onTap: onSettingsTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? TwineColors.darkCard : TwineColors.snow,
            ),
            child: Icon(
              Icons.settings_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
