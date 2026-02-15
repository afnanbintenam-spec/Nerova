import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics.dart';
import '../services/api_client.dart';
import 'task_provider.dart';

class StreakAnalyticsState {
  final UserAnalytics analytics;
  final BurnoutAlert? burnoutAlert;
  final bool isLoading;
  final String? error;

  StreakAnalyticsState({
    required this.analytics,
    this.burnoutAlert,
    this.isLoading = false,
    this.error,
  });

  StreakAnalyticsState copyWith({
    UserAnalytics? analytics,
    BurnoutAlert? burnoutAlert,
    bool? isLoading,
    String? error,
  }) {
    return StreakAnalyticsState(
      analytics: analytics ?? this.analytics,
      burnoutAlert: burnoutAlert ?? this.burnoutAlert,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class StreakAnalyticsNotifier extends StateNotifier<StreakAnalyticsState> {
  final ApiClient _apiClient;

  StreakAnalyticsNotifier(this._apiClient)
    : super(
        StreakAnalyticsState(
          analytics: UserAnalytics(userId: '', lastUpdated: DateTime.now()),
        ),
      ) {
    calculateAnalytics();
  }

  Future<void> calculateAnalytics() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get('/analytics/user');
      final analytics = UserAnalytics.fromJson(
        response as Map<String, dynamic>,
      );

      // Detect burnout
      final alert = _detectBurnout(analytics);

      state = state.copyWith(
        analytics: analytics,
        burnoutAlert: alert,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to calculate analytics: $e',
      );
      _loadMockAnalytics();
    }
  }

  BurnoutAlert? _detectBurnout(UserAnalytics analytics) {
    int riskScore = 0;
    List<String> riskFactors = [];

    // Check focus overload (studying too much)
    if (analytics.dailyStudyHours > 8) {
      riskScore += 20;
      riskFactors.add('You studied ${analytics.dailyStudyHours} hours today');
    }

    // Check low mood streak
    if (analytics.lastSevenDaysMood.isNotEmpty) {
      final avgMood =
          analytics.lastSevenDaysMood.fold(0, (a, b) => a + b) /
          analytics.lastSevenDaysMood.length;
      if (avgMood < 40) {
        riskScore += 25;
        riskFactors.add('Low mood trend detected');
      }
    }

    // Check mood stability
    if (analytics.moodStability < 50) {
      riskScore += 20;
      riskFactors.add('Unstable mood patterns');
    }

    // Check burnout risk
    if (analytics.burnoutRisk > 0) {
      riskScore += analytics.burnoutRisk ~/ 4;
    }

    // Create alert if risk score is high
    if (riskScore >= 60) {
      final message = riskFactors.isEmpty
          ? 'Burnout risk detected. Consider taking a break.'
          : 'Burnout Alert: ${riskFactors.join(", ")}';

      return BurnoutAlert(
        message: message,
        severity: riskScore >= 80 ? 'high' : 'medium',
        suggestedActions: riskScore >= 80
            ? [
                'Take a 24-hour break from studying',
                'Try meditation and stress relief exercises',
                'Focus on light tasks and self-care',
              ]
            : [
                'Try a 30-minute relaxation session',
                'Take frequent short breaks',
                'Reduce daily study hours',
              ],
        detectedAt: DateTime.now(),
      );
    }

    return null;
  }

  void _loadMockAnalytics() {
    final now = DateTime.now();
    final mockMood = [85, 80, 75, 70, 75, 80, 78]; // Last 7 days
    final mockFocus = [6, 7, 8, 5, 6, 7, 8]; // 5-8 hours per day

    final analytics = UserAnalytics(
      userId: 'user1',
      totalFocusHours: 180,
      deepWorkPercent: 72,
      focusStreak: 6,
      moodStability: 82,
      burnoutRisk: 35,
      dailyStudyHours: mockFocus.last,
      lastSevenDaysMood: mockMood,
      lastSevenDaysFocus: mockFocus,
      lastUpdated: now,
    );

    final alert = _detectBurnout(analytics);

    state = state.copyWith(
      analytics: analytics,
      burnoutAlert: alert,
      isLoading: false,
    );
  }
}

final streakAnalyticsProvider =
    StateNotifierProvider<StreakAnalyticsNotifier, StreakAnalyticsState>((ref) {
      return StreakAnalyticsNotifier(ref.watch(apiClientProvider));
    });
