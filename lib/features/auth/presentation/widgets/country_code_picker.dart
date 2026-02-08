import 'package:flutter/material.dart';

import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/widgets/animated/tap_scale.dart';

class CountryCode {
  final String name;
  final String dialCode;
  final String flag;
  const CountryCode(this.name, this.dialCode, this.flag);
}

const _commonCodes = [
  CountryCode('United States', '+1', '🇺🇸'),
  CountryCode('United Kingdom', '+44', '🇬🇧'),
  CountryCode('Canada', '+1', '🇨🇦'),
  CountryCode('Australia', '+61', '🇦🇺'),
  CountryCode('India', '+91', '🇮🇳'),
  CountryCode('Germany', '+49', '🇩🇪'),
  CountryCode('France', '+33', '🇫🇷'),
  CountryCode('Japan', '+81', '🇯🇵'),
  CountryCode('South Korea', '+82', '🇰🇷'),
  CountryCode('Brazil', '+55', '🇧🇷'),
  CountryCode('Mexico', '+52', '🇲🇽'),
  CountryCode('Nigeria', '+234', '🇳🇬'),
  CountryCode('Philippines', '+63', '🇵🇭'),
  CountryCode('South Africa', '+27', '🇿🇦'),
  CountryCode('Singapore', '+65', '🇸🇬'),
];

/// Button that opens a bottom sheet to pick a country code.
class CountryCodePicker extends StatelessWidget {
  const CountryCodePicker({
    super.key,
    required this.selectedCode,
    required this.onChanged,
  });

  final CountryCode selectedCode;
  final ValueChanged<CountryCode> onChanged;

  void _showPicker(BuildContext context) {
    TwineHaptics.selection();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _CountryCodeSheet(
        selected: selectedCode,
        onSelected: (code) {
          onChanged(code);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TwineSpacing.md,
          vertical: TwineSpacing.md,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: TwineColors.silver),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedCode.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: TwineSpacing.xs),
            Text(
              selectedCode.dialCode,
              style: TwineTypography.bodyLg.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TwineSpacing.xs),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }
}

class _CountryCodeSheet extends StatelessWidget {
  const _CountryCodeSheet({
    required this.selected,
    required this.onSelected,
  });

  final CountryCode selected;
  final ValueChanged<CountryCode> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(TwineSpacing.lg),
            child: Text(
              'Select Country',
              style: TwineTypography.headingSm.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _commonCodes.length,
              itemBuilder: (context, index) {
                final code = _commonCodes[index];
                final isSelected = code.dialCode == selected.dialCode &&
                    code.name == selected.name;
                return ListTile(
                  leading: Text(code.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(code.name, style: TwineTypography.bodyMd),
                  trailing: Text(
                    code.dialCode,
                    style: TwineTypography.bodyMd.copyWith(
                      color: TwineColors.slate,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: TwineColors.blush.withAlpha(51),
                  onTap: () {
                    TwineHaptics.selection();
                    onSelected(code);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
