import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twine/core/theme/twine_theme.dart';

import 'app_providers.dart';
import 'router.dart';

/// Root application widget.
class TwineApp extends ConsumerWidget {
  const TwineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Twine',
      debugShowCheckedModeBanner: false,
      theme: TwineTheme.light(),
      darkTheme: TwineTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
