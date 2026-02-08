import 'package:flutter/material.dart';

import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_typography.dart';

/// Twine's 5-tab bottom navigation bar with haptic feedback.
class TwineBottomNavBar extends StatelessWidget {
  const TwineBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NavigationBar(
      selectedIndex: currentIndex,
      backgroundColor: isDark ? TwineColors.darkSurface : TwineColors.white,
      indicatorColor: TwineColors.twineRose.withValues(alpha: 0.12),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      labelTextStyle: WidgetStatePropertyAll(
        TwineTypography.caption.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onDestinationSelected: (index) {
        TwineHaptics.selection();
        onTap(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: TwineColors.twineRose),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble, color: TwineColors.twineRose),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.photo_library_outlined),
          selectedIcon:
              Icon(Icons.photo_library, color: TwineColors.twineRose),
          label: 'Memories',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon:
              Icon(Icons.calendar_today, color: TwineColors.twineRose),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: Icon(Icons.lightbulb_outline),
          selectedIcon: Icon(Icons.lightbulb, color: TwineColors.twineRose),
          label: 'Plan',
        ),
      ],
    );
  }
}
