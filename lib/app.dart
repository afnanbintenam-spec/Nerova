import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/shell/main_shell.dart';

class NeroVaApp extends ConsumerWidget {
  const NeroVaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Nero VA',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: authState.isAuthenticated
          ? const MainShell()
          : const WelcomeScreen(),
    );
  }
}
