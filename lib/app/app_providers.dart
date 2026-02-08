import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current theme mode. Defaults to system.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Stub: whether the user is authenticated.
/// Replace with a real auth state notifier when Supabase is integrated.
final authStatusProvider = StateProvider<bool>((ref) => false);

/// Stub: whether onboarding has been completed.
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Stub: whether the user has a linked partner.
final hasPartnerProvider = StateProvider<bool>((ref) => false);
