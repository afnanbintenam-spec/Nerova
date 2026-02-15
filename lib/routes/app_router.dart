import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/signup_completion_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String signupCompletion = '/signup-completion';
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
        return _buildRoute(const LoginScreen(), settings);

      case AppRoutes.register:
        return _buildRoute(const RegisterScreen(), settings);

      case AppRoutes.otpVerification:
        final email = settings.arguments as String?;
        if (email != null) {
          return _buildRoute(OtpVerificationScreen(email: email), settings);
        }
        return _buildRoute(const _NotFoundScreen(), settings);

      case AppRoutes.signupCompletion:
        return _buildRoute(const SignupCompletionScreen(), settings);

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
                  Navigator.of(context).pushReplacementNamed(AppRoutes.welcome),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
