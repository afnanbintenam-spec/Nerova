import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';

class NeroVaApp extends ConsumerWidget {
  const NeroVaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final router = AppRouter(ref);

    return MaterialApp(
      title: 'Nero VA',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: authState.isAuthenticated
          ? AppRoutes.shell
          : AppRoutes.welcome,
    );
  }
}
