import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_state.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _checkAuth();
  }

  // Check if user is already logged in
  Future<void> _checkAuth() async {
    final token = await _authService.getToken();
    final user = await _authService.getStoredUser();

    if (token != null && user != null) {
      state = AuthState(user: user, token: token);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Use mockLogin for development, replace with _authService.login when backend is ready
    final result = await _authService.mockLogin(email, password);

    if (result['success']) {
      final token = result['token'] as String;
      final user = result['user'] as User;

      await _authService.storeAuth(token, user);

      state = AuthState(user: user, token: token);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result['error'] as String,
      );
      return false;
    }
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Mock implementation for now
    await Future.delayed(const Duration(seconds: 1));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
      );
      final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

      await _authService.storeAuth(token, user);

      state = AuthState(user: user, token: token);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Please fill all fields correctly',
      );
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.clearAuth();
    state = const AuthState();
  }

  // Clear error
  void clearError() {
    state = state.clearError();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
