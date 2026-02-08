import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_typography.dart';

/// Twine avatar with network image, initials fallback, and online indicator.
class TwineAvatar extends StatelessWidget {
  const TwineAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = TwineAvatarSize.medium,
    this.showOnlineIndicator = false,
    this.isOnline = false,
  });

  final String? imageUrl;
  final String? name;
  final TwineAvatarSize size;
  final bool showOnlineIndicator;
  final bool isOnline;

  double get _diameter => switch (size) {
        TwineAvatarSize.small => 32,
        TwineAvatarSize.medium => 48,
        TwineAvatarSize.large => 80,
      };

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final diameter = _diameter;
    final indicatorSize = diameter * 0.25;

    Widget avatar = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: TwineColors.blush,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                _initials,
                style: (size == TwineAvatarSize.large
                        ? TwineTypography.headingLg
                        : size == TwineAvatarSize.medium
                            ? TwineTypography.bodyLg
                            : TwineTypography.bodySm)
                    .copyWith(
                  color: TwineColors.twineRose,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );

    if (showOnlineIndicator) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? TwineColors.success : TwineColors.gray,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return avatar;
  }
}

enum TwineAvatarSize { small, medium, large }
