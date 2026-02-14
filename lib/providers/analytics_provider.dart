import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../models/mood.dart';
import 'task_provider.dart';
import 'mood_provider.dart';

// Analytics state
class AnalyticsState {
  final int totalTasks;
  final int completedTasks;
  final int overdueTasks;
  final int overdueCount;
  final double completionRate;
  final int focusMinutesToday;
  final int studyStreak;
  final double averageEnergy;
  final double averageStress;
  final String? dominantMood;
  final Map<String, int> tasksByPriority;
  final Map<String, int> tasksByCourse;
  final List<DailyProductivity> weeklyProductivity;
  final bool isLoading;
  final String? error;

  AnalyticsState({
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.overdueTasks = 0,
    this.overdueCount = 0,
    this.completionRate = 0.0,
    this.focusMinutesToday = 0,
    this.studyStreak = 0,
    this.averageEnergy = 0.0,
    this.averageStress = 0.0,
    this.dominantMood,
    this.tasksByPriority = const {},
    this.tasksByCourse = const {},
    this.weeklyProductivity = const [],
    this.isLoading = false,
    this.error,
  });

  AnalyticsState copyWith({
    int? totalTasks,
    int? completedTasks,
    int? overdueTasks,
    int? overdueCount,
    double? completionRate,
    int? focusMinutesToday,
    int? studyStreak,
    double? averageEnergy,
    double? averageStress,
    String? dominantMood,
    Map<String, int>? tasksByPriority,
    Map<String, int>? tasksByCourse,
    List<DailyProductivity>? weeklyProductivity,
    bool? isLoading,
    String? error,
  }) {
    return AnalyticsState(
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      overdueTasks: overdueTasks ?? this.overdueTasks,
      overdueCount: overdueCount ?? this.overdueCount,
      completionRate: completionRate ?? this.completionRate,
      focusMinutesToday: focusMinutesToday ?? this.focusMinutesToday,
      studyStreak: studyStreak ?? this.studyStreak,
      averageEnergy: averageEnergy ?? this.averageEnergy,
      averageStress: averageStress ?? this.averageStress,
      dominantMood: dominantMood ?? this.dominantMood,
      tasksByPriority: tasksByPriority ?? this.tasksByPriority,
      tasksByCourse: tasksByCourse ?? this.tasksByCourse,
      weeklyProductivity: weeklyProductivity ?? this.weeklyProductivity,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DailyProductivity {
  final DateTime date;
  final int completedTasks;
  final int focusMinutes;
  final double energy;

  DailyProductivity({
    required this.date,
    required this.completedTasks,
    required this.focusMinutes,
    required this.energy,
  });
}

// Analytics notifier
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final Ref _ref;

  AnalyticsNotifier(this._ref) : super(AnalyticsState()) {
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final taskState = _ref.read(taskListProvider);
      final moodState = _ref.read(moodProvider);

      // Task analytics
      final tasks = taskState.tasks;
      final totalTasks = tasks.length;
      final completedTasks = tasks.where((t) => t.isCompleted).length;
      final overdueTasks = tasks.where((t) => t.isOverdue).length;
      final completionRate = totalTasks > 0
          ? (completedTasks / totalTasks) * 100
          : 0.0;

      // Task by priority
      final tasksByPriority = <String, int>{};
      for (var task in tasks) {
        tasksByPriority[task.priority] =
            (tasksByPriority[task.priority] ?? 0) + 1;
      }

      // Tasks by course
      final tasksByCourse = <String, int>{};
      for (var task in tasks.where((t) => t.course != null)) {
        tasksByCourse[task.course!] = (tasksByCourse[task.course!] ?? 0) + 1;
      }

      // Mood analytics
      final averageEnergy = moodState.averageEnergy;
      final averageStress = moodState.averageStress;
      final dominantMood = moodState.dominantMood;

      // Weekly productivity (mock data)
      final weeklyProductivity = _generateWeeklyProductivity(
        tasks,
        moodState.moods,
      );

      state = state.copyWith(
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        overdueTasks: overdueTasks,
        overdueCount: overdueTasks,
        completionRate: completionRate,
        focusMinutesToday: 125, // Mock data
        studyStreak: 4, // Mock data
        averageEnergy: averageEnergy,
        averageStress: averageStress,
        dominantMood: dominantMood,
        tasksByPriority: tasksByPriority,
        tasksByCourse: tasksByCourse,
        weeklyProductivity: weeklyProductivity,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load analytics: ${e.toString()}',
      );
    }
  }

  List<DailyProductivity> _generateWeeklyProductivity(
    List<Task> tasks,
    List<Mood> moods,
  ) {
    final now = DateTime.now();
    final productivity = <DailyProductivity>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      // Count completed tasks for this day
      final completedCount = tasks.where((task) {
        return task.isCompleted &&
            task.updatedAt.isAfter(dayStart) &&
            task.updatedAt.isBefore(dayEnd);
      }).length;

      // Get energy for this day
      final dayMood = moods.firstWhere(
        (mood) =>
            mood.timestamp.isAfter(dayStart) && mood.timestamp.isBefore(dayEnd),
        orElse: () => Mood(
          id: '',
          mood: 'neutral',
          energy: 3,
          stress: 3,
          timestamp: dayStart,
        ),
      );

      productivity.add(
        DailyProductivity(
          date: date,
          completedTasks: completedCount,
          focusMinutes: (completedCount * 25), // Estimate 25 min per task
          energy: dayMood.energy.toDouble(),
        ),
      );
    }

    return productivity;
  }

  Future<void> refresh() async {
    await _loadAnalytics();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Analytics provider
final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
      return AnalyticsNotifier(ref);
    });
