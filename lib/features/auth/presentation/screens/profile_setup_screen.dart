import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twine/app/app_providers.dart';
import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/utils/extensions.dart';
import 'package:twine/core/utils/validators.dart';
import 'package:twine/core/widgets/animated/confetti.dart';
import 'package:twine/core/widgets/animated/stagger_animation.dart';
import 'package:twine/shared/widgets/buttons/twine_button.dart';
import 'package:twine/shared/widgets/cards/twine_card.dart';
import 'package:twine/shared/widgets/display/twine_avatar.dart';
import 'package:twine/shared/widgets/layout/twine_scaffold.dart';

import '../../domain/auth_state.dart' show AuthAuthenticated;
import '../../providers/auth_providers.dart';
import '../widgets/profile_photo_picker.dart';
import '../widgets/setup_progress_indicator.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      ref
          .read(profileSetupNotifierProvider.notifier)
          .setDisplayName(_nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? get _userId {
    final authState = ref.read(authNotifierProvider);
    if (authState is AuthAuthenticated) return authState.userId;
    return null;
  }

  void _nextStep() {
    TwineHaptics.selection();
    ref.read(profileSetupNotifierProvider.notifier).nextStep();
  }

  void _previousStep() {
    TwineHaptics.selection();
    ref.read(profileSetupNotifierProvider.notifier).previousStep();
  }

  Future<void> _complete() async {
    final userId = _userId;
    if (userId == null) return;

    TwineHaptics.medium();
    final notifier = ref.read(profileSetupNotifierProvider.notifier);
    final success = await notifier.saveProfile(userId);

    if (success && mounted) {
      setState(() => _showCelebration = true);
      await TwineHaptics.celebration();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        ref.read(onboardingCompleteProvider.notifier).state = true;
        // Router redirect handles navigation to /setup/invite
      }
    } else if (mounted) {
      final error = ref.read(profileSetupNotifierProvider).error;
      if (error != null) {
        context.showErrorSnackBar(error);
      }
    }
  }

  Future<void> _pickDate({required bool isBirthday}) async {
    TwineHaptics.selection();
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: isBirthday
          ? DateTime(now.year - 25)
          : now.subtract(const Duration(days: 365)),
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (date != null) {
      final notifier = ref.read(profileSetupNotifierProvider.notifier);
      if (isBirthday) {
        notifier.setBirthday(date);
      } else {
        notifier.setAnniversary(date);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final setupState = ref.watch(profileSetupNotifierProvider);

    return CelebrationOverlay(
      celebrate: _showCelebration,
      intensity: ConfettiIntensity.subtle,
      colors: const [TwineColors.twineRose, TwineColors.coral, TwineColors.blush],
      child: TwineScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: setupState.currentStep > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousStep,
                )
              : null,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: TwineSpacing.screenPadding,
          child: Column(
            children: [
              SetupProgressIndicator(currentStep: setupState.currentStep),
              const SizedBox(height: TwineSpacing.xxl),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: switch (setupState.currentStep) {
                    0 => _NameStep(
                        key: const ValueKey('name'),
                        controller: _nameController,
                        displayName: setupState.displayName,
                        onNext: setupState.canProceedFromName
                            ? _nextStep
                            : null,
                      ),
                    1 => _PhotoStep(
                        key: const ValueKey('photo'),
                        photoPath: setupState.photoPath,
                        onPhotoSelected: (path) => ref
                            .read(profileSetupNotifierProvider.notifier)
                            .setPhotoPath(path),
                        onNext: _nextStep,
                        onSkip: _nextStep,
                      ),
                    _ => _DatesStep(
                        key: const ValueKey('dates'),
                        birthday: setupState.birthday,
                        anniversary: setupState.anniversary,
                        onPickBirthday: () => _pickDate(isBirthday: true),
                        onPickAnniversary: () => _pickDate(isBirthday: false),
                        onComplete: _complete,
                        isSaving: setupState.isSaving,
                      ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Step 1: Name ──────────────────────────────────────────────

class _NameStep extends StatelessWidget {
  const _NameStep({
    super.key,
    required this.controller,
    required this.displayName,
    this.onNext,
  });

  final TextEditingController controller;
  final String displayName;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return StaggeredColumn(
      staggerDelay: const Duration(milliseconds: 50),
      duration: const Duration(milliseconds: 300),
      animation: StaggerAnimation.fadeSlideUp,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TwineAvatar(
          name: displayName.isEmpty ? null : displayName,
          size: TwineAvatarSize.large,
        ),
        const SizedBox(height: TwineSpacing.xl),
        Text(
          'What should we call you?',
          style: TwineTypography.headingMd.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TwineSpacing.xl),
        TextFormField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.words,
          style: TwineTypography.headingSm.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: const InputDecoration(
            hintText: 'Your display name',
          ),
          validator: TwineValidators.displayName,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => onNext?.call(),
        ),
        const Spacer(),
        TwineButton.primary(
          label: 'Continue',
          onPressed: onNext,
          isFullWidth: true,
          enabled: onNext != null,
        ),
        const SizedBox(height: TwineSpacing.lg),
      ],
    );
  }
}

// ─── Step 2: Photo ─────────────────────────────────────────────

class _PhotoStep extends StatelessWidget {
  const _PhotoStep({
    super.key,
    this.photoPath,
    required this.onPhotoSelected,
    required this.onNext,
    required this.onSkip,
  });

  final String? photoPath;
  final ValueChanged<String?> onPhotoSelected;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return StaggeredColumn(
      staggerDelay: const Duration(milliseconds: 50),
      duration: const Duration(milliseconds: 300),
      animation: StaggerAnimation.fadeSlideUp,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Add a profile photo',
          style: TwineTypography.headingMd.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TwineSpacing.sm),
        Text(
          'Help your partner recognize you!',
          style: TwineTypography.bodyMd.copyWith(
            color: TwineColors.slate,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TwineSpacing.xxxl),
        ProfilePhotoPicker(
          photoPath: photoPath,
          onPhotoSelected: onPhotoSelected,
        ),
        const Spacer(),
        TwineButton.primary(
          label: photoPath != null ? 'Continue' : 'Continue with Photo',
          onPressed: onNext,
          isFullWidth: true,
          enabled: photoPath != null,
        ),
        const SizedBox(height: TwineSpacing.sm),
        TwineButton.text(
          label: 'Skip for now',
          onPressed: onSkip,
        ),
        const SizedBox(height: TwineSpacing.lg),
      ],
    );
  }
}

// ─── Step 3: Dates ─────────────────────────────────────────────

class _DatesStep extends StatelessWidget {
  const _DatesStep({
    super.key,
    this.birthday,
    this.anniversary,
    required this.onPickBirthday,
    required this.onPickAnniversary,
    required this.onComplete,
    this.isSaving = false,
  });

  final DateTime? birthday;
  final DateTime? anniversary;
  final VoidCallback onPickBirthday;
  final VoidCallback onPickAnniversary;
  final VoidCallback onComplete;
  final bool isSaving;

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredColumn(
      staggerDelay: const Duration(milliseconds: 50),
      duration: const Duration(milliseconds: 300),
      animation: StaggerAnimation.fadeSlideUp,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Important dates',
          style: TwineTypography.headingMd.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TwineSpacing.sm),
        Text(
          'We\'ll help you remember and celebrate.',
          style: TwineTypography.bodyMd.copyWith(
            color: TwineColors.slate,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TwineSpacing.xxl),
        TwineCard(
          onTap: onPickBirthday,
          child: Row(
            children: [
              const Icon(Icons.cake_rounded, color: TwineColors.twineRose),
              const SizedBox(width: TwineSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Birthday',
                      style: TwineTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      birthday != null
                          ? _formatDate(birthday!)
                          : 'Tap to select',
                      style: TwineTypography.bodySm.copyWith(
                        color: birthday != null
                            ? TwineColors.slate
                            : TwineColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: TwineColors.gray),
            ],
          ),
        ),
        const SizedBox(height: TwineSpacing.md),
        TwineCard(
          onTap: onPickAnniversary,
          child: Row(
            children: [
              const Icon(Icons.favorite_rounded, color: TwineColors.coral),
              const SizedBox(width: TwineSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anniversary',
                      style: TwineTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      anniversary != null
                          ? _formatDate(anniversary!)
                          : 'Tap to select (optional)',
                      style: TwineTypography.bodySm.copyWith(
                        color: anniversary != null
                            ? TwineColors.slate
                            : TwineColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: TwineColors.gray),
            ],
          ),
        ),
        const Spacer(),
        TwineButton.primary(
          label: 'Complete Setup',
          onPressed: !isSaving ? onComplete : null,
          isLoading: isSaving,
          isFullWidth: true,
        ),
        const SizedBox(height: TwineSpacing.lg),
      ],
    );
  }
}
