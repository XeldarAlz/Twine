import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:twine/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:twine/features/auth/presentation/screens/phone_input_screen.dart';
import 'package:twine/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:twine/features/onboarding/presentation/screens/onboarding_screen.dart';

import 'app_providers.dart';

/// Global GoRouter provider.
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(authStatusProvider);
  final hasOnboarded = ref.watch(onboardingCompleteProvider);
  final hasPartner = ref.watch(hasPartnerProvider);

  return GoRouter(
    initialLocation: '/welcome',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isAuthRoute = loc.startsWith('/welcome') ||
          loc.startsWith('/login');

      // Not authenticated -> force auth flow
      if (!isAuthenticated && !isAuthRoute) return '/welcome';

      // Authenticated but on auth route -> redirect forward
      if (isAuthenticated && isAuthRoute) {
        if (!hasOnboarded) return '/setup/profile';
        if (!hasPartner) return '/setup/invite';
        return '/home';
      }

      // Authenticated, setup incomplete -> force setup
      if (isAuthenticated && !hasOnboarded && !loc.startsWith('/setup')) {
        return '/setup/profile';
      }
      if (isAuthenticated &&
          hasOnboarded &&
          !hasPartner &&
          !loc.startsWith('/setup')) {
        return '/setup/invite';
      }

      return null;
    },
    routes: [
      // --- Auth flow ---
      GoRoute(
        path: '/welcome',
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => const PhoneInputScreen(),
        routes: [
          GoRoute(
            path: 'verify',
            builder: (_, _) => const OtpVerificationScreen(),
          ),
        ],
      ),

      // --- Setup flow ---
      GoRoute(
        path: '/setup/profile',
        builder: (_, _) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/setup/invite',
        builder: (_, _) => const _PlaceholderScreen(title: 'Invite Partner'),
      ),
      GoRoute(
        path: '/setup/enter-code',
        builder: (_, _) => const _PlaceholderScreen(title: 'Enter Code'),
      ),
      GoRoute(
        path: '/setup/connected',
        builder: (_, _) =>
            const _PlaceholderScreen(title: 'Connection Success'),
      ),

      // --- Main shell with bottom navigation ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (_, _) =>
                  const _PlaceholderScreen(title: 'Dashboard'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/chat',
              builder: (_, _) => const _PlaceholderScreen(title: 'Chat'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/memories',
              builder: (_, _) =>
                  const _PlaceholderScreen(title: 'Memories'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/calendar',
              builder: (_, _) =>
                  const _PlaceholderScreen(title: 'Calendar'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/plan',
              builder: (_, _) =>
                  const _PlaceholderScreen(title: 'Plan'),
            ),
          ]),
        ],
      ),

      // --- Settings (full screen, outside shell) ---
      GoRoute(
        path: '/settings',
        builder: (_, _) => const _PlaceholderScreen(title: 'Settings'),
      ),
    ],
  );
});

// --- Main Shell ---

class _MainShell extends StatelessWidget {
  const _MainShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Memories',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Plan',
          ),
        ],
      ),
    );
  }
}

// --- Placeholder Screen ---

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
