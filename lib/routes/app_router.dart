import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/exams/exam_hub_screen.dart';
import '../screens/courses/courses_screen.dart';
import '../screens/vault/knowledge_vault_screen.dart';
import '../screens/stress_support/stress_support_screen.dart';
import '../screens/task_details/task_detail_screen.dart';
import '../screens/insights/analytics_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String planner = '/planner';
  static const String ai = '/ai';
  static const String focus = '/focus';
  static const String insights = '/insights';
  static const String analytics = '/analytics';
  static const String shell = '/shell';
  static const String exams = '/exams';
  static const String courses = '/courses';
  static const String vault = '/vault';
  static const String stressSupport = '/stress-support';
  static const String taskDetails = '/task-details';
}

class AppRouter {
  final WidgetRef ref;

  AppRouter(this.ref);

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final authState = ref.read(authProvider);

    // Check if user is authenticated
    final isAuthenticated = authState.isAuthenticated;

    // Splash screen (always shown first)
    if (settings.name == null || settings.name == AppRoutes.splash) {
      return _buildRoute(const SplashScreen(), settings);
    }

    // Public routes (no auth required)
    switch (settings.name) {
      case AppRoutes.welcome:
        return _buildRoute(const WelcomeScreen(), settings);

      case AppRoutes.login:
        if (isAuthenticated) {
          // Redirect to home if already authenticated
          return _buildRoute(const MainShell(), settings);
        }
        return _buildRoute(const LoginScreen(), settings);

      case AppRoutes.register:
        if (isAuthenticated) {
          // Redirect to home if already authenticated
          return _buildRoute(const MainShell(), settings);
        }
        return _buildRoute(const RegisterScreen(), settings);
    }

    // Protected routes (auth required)
    if (!isAuthenticated) {
      // Redirect to login if not authenticated
      return _buildRoute(const LoginScreen(), settings);
    }

    switch (settings.name) {
      case AppRoutes.shell:
      case AppRoutes.home:
        return _buildRoute(const MainShell(), settings);

      case AppRoutes.planner:
        return _buildRoute(const MainShell(initialIndex: 1), settings);

      case AppRoutes.ai:
        return _buildRoute(const MainShell(initialIndex: 2), settings);

      case AppRoutes.focus:
        return _buildRoute(const MainShell(initialIndex: 3), settings);

      case AppRoutes.insights:
        return _buildRoute(const MainShell(initialIndex: 4), settings);

      case AppRoutes.exams:
        return _buildRoute(const ExamHubScreen(), settings);

      case AppRoutes.courses:
        return _buildRoute(const CoursesScreen(), settings);

      case AppRoutes.vault:
        return _buildRoute(const KnowledgeVaultScreen(), settings);

      case AppRoutes.stressSupport:
        return _buildRoute(const StressSupportScreen(), settings);

      case AppRoutes.analytics:
        return _buildRoute(const AnalyticsScreen(), settings);

      case AppRoutes.taskDetails:
        // Extract task from arguments
        final task = settings.arguments as Task?;
        if (task != null) {
          return _buildRoute(TaskDetailScreen(task: task), settings);
        }
        return _buildRoute(const _NotFoundScreen(), settings);

      default:
        return _buildRoute(const _NotFoundScreen(), settings);
    }
  }

  MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              '404',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Page not found'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
