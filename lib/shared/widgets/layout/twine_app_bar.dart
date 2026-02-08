import 'package:flutter/material.dart';

import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

/// Consistent Twine app bar with haptic-enabled back button.
class TwineAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TwineAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TwineTypography.headingMd),
      leading: showBack && Navigator.of(context).canPop()
          ? TapScale(
              onTap: () {
                TwineHaptics.light();
                if (onBack != null) {
                  onBack!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Icon(Icons.arrow_back_ios_new, size: 20),
            )
          : null,
      actions: actions,
    );
  }
}
