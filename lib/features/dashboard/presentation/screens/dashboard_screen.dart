import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:twine/core/theme/twine_colors.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/theme/twine_typography.dart';
import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/utils/extensions.dart';
import 'package:twine/core/widgets/animated/shimmer_loading.dart';
import 'package:twine/core/widgets/animated/stagger_animation.dart';
import 'package:twine/shared/widgets/buttons/twine_button.dart';

import '../../domain/dashboard_state.dart';
import '../../providers/dashboard_providers.dart';
import '../widgets/greeting_header.dart';
import '../widgets/partner_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/daily_question_card.dart';
import '../widgets/mood_section.dart';
import '../widgets/mood_picker_sheet.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Future<void> _showMoodPicker() async {
    TwineHaptics.bottomSheetSnap();
    final mood = await showModalBottomSheet<MoodType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const MoodPickerSheet(),
    );
    if (mood != null && mounted) {
      ref.read(dashboardNotifierProvider.notifier).setMood(mood);
    }
  }

  void _onSendTap() {
    ref.read(dashboardNotifierProvider.notifier).sendTap();
    context.showSnackBar('Tap sent! 💗');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: TwineColors.twineRose,
          onRefresh: () =>
              ref.read(dashboardNotifierProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: TwineSpacing.lg,
              vertical: TwineSpacing.xl,
            ),
            child: switch (state) {
              DashboardInitial() || DashboardLoading() => _buildLoading(),
              DashboardError(:final message) => _buildError(message),
              DashboardLoaded(:final data) => _buildLoaded(data),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Greeting skeleton
        ShimmerLoading(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox.text(width: 100),
                    SizedBox(height: 8),
                    SkeletonBox.title(width: 160),
                  ],
                ),
              ),
              const SkeletonCircle(size: 40),
            ],
          ),
        ),
        const SizedBox(height: TwineSpacing.xl),

        // Partner card skeleton
        const SkeletonPartnerCard(),
        const SizedBox(height: TwineSpacing.xl),

        // Quick actions skeleton
        ShimmerLoading(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (_) => const Column(
                children: [
                  SkeletonCircle(size: 56),
                  SizedBox(height: 8),
                  SkeletonBox.text(width: 50),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: TwineSpacing.xl),

        // Question card skeleton
        ShimmerLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBox.text(width: 120),
              SizedBox(height: 12),
              SkeletonBox(height: 40, width: double.infinity),
              SizedBox(height: 12),
              SkeletonBox.button(width: double.infinity),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: TwineColors.gray,
            ),
            const SizedBox(height: TwineSpacing.lg),
            Text(
              'Something went wrong',
              style: TwineTypography.headingSm.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: TwineSpacing.sm),
            Text(
              message,
              style: TwineTypography.bodyMd.copyWith(
                color: TwineColors.gray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TwineSpacing.xl),
            TwineButton.primary(
              label: 'Retry',
              onPressed: () =>
                  ref.read(dashboardNotifierProvider.notifier).refresh(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(DashboardData data) {
    return StaggeredColumn(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Greeting
        GreetingHeader(
          userName: data.userName,
          onSettingsTap: () => context.push('/settings'),
        ),
        const SizedBox(height: TwineSpacing.xl),

        // Partner card
        PartnerCard(data: data),
        const SizedBox(height: TwineSpacing.xl),

        // Quick actions
        QuickActionsRow(
          onSendTap: _onSendTap,
          onSharePhoto: () {}, // TODO: implement
          onDailyQuestion: () {}, // TODO: implement
        ),
        const SizedBox(height: TwineSpacing.xl),

        // Mood section
        MoodSection(
          currentMood: data.currentMood,
          onSetMood: _showMoodPicker,
        ),
        const SizedBox(height: TwineSpacing.xl),

        // Daily question
        DailyQuestionCard(
          question: data.todaysQuestion,
          questionState: data.questionState,
        ),
        const SizedBox(height: TwineSpacing.xl),

        // Recent activity
        if (data.recentActivity.isNotEmpty) ...[
          Text(
            'Recent Activity',
            style: TwineTypography.headingSm.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: TwineSpacing.md),
          ...data.recentActivity.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: TwineSpacing.sm),
                child: _ActivityRow(activity: activity),
              )),
        ],

        // Bottom padding for nav bar clearance
        const SizedBox(height: TwineSpacing.xxl),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: TwineColors.twineRose.withValues(alpha: 0.10),
          ),
          child: Icon(
            activity.type.icon,
            size: 16,
            color: TwineColors.twineRose,
          ),
        ),
        const SizedBox(width: TwineSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.description,
                style: TwineTypography.bodyMd.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                activity.timestamp.relativeTime,
                style: TwineTypography.bodySm.copyWith(
                  color: TwineColors.gray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
