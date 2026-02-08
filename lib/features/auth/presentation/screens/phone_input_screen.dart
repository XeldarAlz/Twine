import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/utils/extensions.dart';
import 'package:twine/core/widgets/animated/stagger_animation.dart';
import 'package:twine/shared/widgets/buttons/twine_button.dart';
import 'package:twine/shared/widgets/layout/twine_scaffold.dart';

import '../../domain/auth_state.dart';
import '../../providers/auth_providers.dart';
import '../widgets/country_code_picker.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  var _selectedCountry = const CountryCode('United States', '+1', '🇺🇸');

  String get _fullPhoneNumber =>
      '${_selectedCountry.dialCode}${_phoneController.text.trim()}';

  bool get _isPhoneValid => _phoneController.text.trim().length >= 7;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (!_isPhoneValid) return;
    TwineHaptics.medium();
    ref.read(authNotifierProvider.notifier).sendOtp(_fullPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is AuthOtpSent) {
        context.go('/login/verify');
      } else if (next is AuthError) {
        context.showErrorSnackBar(next.message);
      }
    });

    final isLoading = authState is AuthLoading;

    return TwineScaffold(
      body: Padding(
        padding: TwineSpacing.screenPadding,
        child: StaggeredColumn(
          staggerDelay: const Duration(milliseconds: 50),
          duration: const Duration(milliseconds: 300),
          animation: StaggerAnimation.fadeSlideUp,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TwineSpacing.xxxl),
            Text(
              'What\'s your\nphone number?',
              style: TwineTypography.displayMd.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: TwineSpacing.sm),
            Text(
              'We\'ll send you a verification code.',
              style: TwineTypography.bodyLg.copyWith(
                color: TwineColors.slate,
              ),
            ),
            const SizedBox(height: TwineSpacing.xxl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CountryCodePicker(
                  selectedCode: _selectedCountry,
                  onChanged: (code) =>
                      setState(() => _selectedCountry = code),
                ),
                const SizedBox(width: TwineSpacing.sm),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    style: TwineTypography.bodyLg.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Phone number',
                    ),
                    onChanged: (_) => setState(() {}),
                    onFieldSubmitted: (_) => _sendCode(),
                  ),
                ),
              ],
            ),
            const Spacer(),
            TwineButton.primary(
              label: 'Send Code',
              onPressed: _isPhoneValid && !isLoading ? _sendCode : null,
              isLoading: isLoading,
              isFullWidth: true,
            ),
            const SizedBox(height: TwineSpacing.lg),
          ],
        ),
      ),
    );
  }
}
