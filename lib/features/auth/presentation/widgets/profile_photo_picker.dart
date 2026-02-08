import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

/// Dashed-circle photo picker with camera/gallery bottom sheet.
class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({
    super.key,
    this.photoPath,
    required this.onPhotoSelected,
  });

  final String? photoPath;
  final ValueChanged<String?> onPhotoSelected;

  void _showOptions(BuildContext context) {
    TwineHaptics.selection();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TwineSpacing.lg),
            Text(
              'Add a Photo',
              style: TwineTypography.headingSm.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: TwineSpacing.lg),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text('Take Photo', style: TwineTypography.bodyLg),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text('Choose from Gallery', style: TwineTypography.bodyLg),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.gallery);
              },
            ),
            const SizedBox(height: TwineSpacing.lg),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    TwineHaptics.photoCapture();
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        onPhotoSelected(image.path);
      }
    } catch (_) {
      // Silently handle permission denial or cancellation.
    }
  }

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: () => _showOptions(context),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: photoPath != null ? null : TwineColors.snow,
          border: Border.all(
            color: TwineColors.silver,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          image: photoPath != null
              ? DecorationImage(
                  image: AssetImage(photoPath!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: photoPath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_rounded,
                    size: 32,
                    color: TwineColors.gray,
                  ),
                  const SizedBox(height: TwineSpacing.xs),
                  Text(
                    'Add photo',
                    style: TwineTypography.caption.copyWith(
                      color: TwineColors.gray,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
