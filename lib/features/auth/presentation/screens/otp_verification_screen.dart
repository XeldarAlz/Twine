import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twine/app/app_providers.dart';
import 'package:twine/core/constants/app_constants.dart';
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
import '../widgets/otp_input.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends ConsumerState<OtpVerificationScreen> {
  final _otpKey = GlobalKey<OtpInputState>();
  Timer? _resendTimer;
  int _resendSeconds = AppConstants.otpResendCooldown.inSeconds;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendSeconds = AppConstants.otpResendCooldown.inSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  String get _phoneNumber {
    final authState = ref.read(authNotifierProvider);
    if (authState is AuthOtpSent) return authState.phoneNumber;
    return '';
  }

  void _onOtpCompleted(String code) {
    setState(() => _hasError = false);
    TwineHaptics.medium();
    ref.read(authNotifierProvider.notifier).verifyOtp(_phoneNumber, code);
  }

  void _resendCode() {
    if (_resendSeconds > 0) return;
    TwineHaptics.selection();
    ref.read(authNotifierProvider.notifier).sendOtp(_phoneNumber);
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is AuthAuthenticated) {
        TwineHaptics.success();
        ref.read(authStatusProvider.notifier).state = true;
        // Router redirect handles navigation to /setup/profile
      } else if (next is AuthError) {
        setState(() => _hasError = true);
        context.showErrorSnackBar(next.message);
        _otpKey.currentState?.clear();
      }
    });

    final isLoading = authState is AuthOtpVerifying;

    return TwineScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: TwineSpacing.screenPadding,
        child: StaggeredColumn(
          staggerDelay: const Duration(milliseconds: 50),
          duration: const Duration(milliseconds: 300),
          animation: StaggerAnimation.fadeSlideUp,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: TwineSpacing.xl),
            Text(
              'Enter verification code',
              style: TwineTypography.displaySm.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TwineSpacing.sm),
            Text(
              'We sent a code to $_phoneNumber',
              style: TwineTypography.bodyMd.copyWith(
                color: TwineColors.slate,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TwineSpacing.xxxl),
            AbsorbPointer(
              absorbing: isLoading,
              child: Opacity(
                opacity: isLoading ? 0.5 : 1.0,
                child: OtpInput(
                  key: _otpKey,
                  onCompleted: _onOtpCompleted,
                  hasError: _hasError,
                ),
              ),
            ),
            const SizedBox(height: TwineSpacing.xxl),
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              _resendSeconds > 0
                  ? Text(
                      'Resend code in ${_resendSeconds}s',
                      style: TwineTypography.bodyMd.copyWith(
                        color: TwineColors.gray,
                      ),
                    )
                  : TwineButton.text(
                      label: 'Resend Code',
                      onPressed: _resendCode,
                    ),
          ],
        ),
      ),
    );
  }
}
