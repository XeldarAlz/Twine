import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:twine/core/services/haptic_service.dart';
import 'package:twine/core/theme/twine_spacing.dart';
import 'package:twine/core/widgets/animated/heartbeat_animation.dart';
import 'package:twine/shared/widgets/buttons/twine_button.dart';
import 'package:twine/shared/widgets/layout/twine_scaffold.dart';

import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  double _currentPage = 0;

  static const _pages = [
    _PageData(
      icon: Icons.favorite_rounded,
      title: 'Stay Connected',
      subtitle:
          'Share your moments, feelings, and love — no matter the distance.',
    ),
    _PageData(
      icon: Icons.touch_app_rounded,
      title: 'Feel Their Presence',
      subtitle:
          'Send a tap and feel your partner\'s heartbeat in real time.',
    ),
    _PageData(
      icon: Icons.calendar_month_rounded,
      title: 'Never Miss a Moment',
      subtitle:
          'Track milestones, plan dates, and celebrate your journey together.',
    ),
    _PageData(
      icon: Icons.auto_awesome_rounded,
      title: 'Your Relationship OS',
      subtitle:
          'Everything you need for a thriving relationship, in one place.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _currentPage = _pageController.page ?? 0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage.round() == _pages.length - 1;

  void _onNext() {
    TwineHaptics.selection();
    if (_isLastPage) {
      context.go('/login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onSkip() {
    TwineHaptics.selection();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return TwineScaffold(
      body: Column(
        children: [
          // Skip button
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: TwineSpacing.sm,
                right: TwineSpacing.sm,
              ),
              child: _isLastPage
                  ? const SizedBox(height: 40)
                  : TwineButton.text(
                      label: 'Skip',
                      onPressed: _onSkip,
                    ),
            ),
          ),

          // Pages
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  icon: _pages[index].icon,
                  title: _pages[index].title,
                  subtitle: _pages[index].subtitle,
                );
              },
            ),
          ),

          // Bottom section
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TwineSpacing.xl,
              TwineSpacing.lg,
              TwineSpacing.xl,
              TwineSpacing.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PageIndicator(
                  count: _pages.length,
                  currentPage: _currentPage,
                ),
                const SizedBox(height: TwineSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: _isLastPage
                      ? HeartbeatAnimation.subtle(
                          child: TwineButton.primary(
                            label: 'Get Started',
                            onPressed: _onNext,
                            isFullWidth: true,
                          ),
                        )
                      : TwineButton.primary(
                          label: 'Next',
                          onPressed: _onNext,
                          isFullWidth: true,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _PageData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
