class UserAnalytics {
  final String userId;
  final int totalFocusHours;
  final int deepWorkPercent;
  final int focusStreak;
  final double moodStability;
  final int burnoutRisk; // 0-100 score
  final int dailyStudyHours;
  final List<int> lastSevenDaysMood; // 0-100 scores
  final List<int> lastSevenDaysFocus; // hours per day
  final List<double> focusHours; // 7-day trend
  final List<double> moodScores; // 7-day mood scores
  final double deepWorkPercentage;
  final int completedTasks;
  final DateTime lastUpdated;

  UserAnalytics({
    required this.userId,
    this.totalFocusHours = 0,
    this.deepWorkPercent = 0,
    this.focusStreak = 0,
    this.moodStability = 100,
    this.burnoutRisk = 0,
    this.dailyStudyHours = 0,
    this.lastSevenDaysMood = const [],
    this.lastSevenDaysFocus = const [],
    this.focusHours = const [],
    this.moodScores = const [],
    this.deepWorkPercentage = 0,
    this.completedTasks = 0,
    required this.lastUpdated,
  });

  bool get isHighBurnoutRisk => burnoutRisk >= 70;

  bool get isMediumBurnoutRisk => burnoutRisk >= 40 && burnoutRisk < 70;

  UserAnalytics copyWith({
    String? userId,
    int? totalFocusHours,
    int? deepWorkPercent,
    int? focusStreak,
    double? moodStability,
    int? burnoutRisk,
    int? dailyStudyHours,
    List<int>? lastSevenDaysMood,
    List<int>? lastSevenDaysFocus,
    List<double>? focusHours,
    List<double>? moodScores,
    double? deepWorkPercentage,
    int? completedTasks,
    DateTime? lastUpdated,
  }) {
    return UserAnalytics(
      userId: userId ?? this.userId,
      totalFocusHours: totalFocusHours ?? this.totalFocusHours,
      deepWorkPercent: deepWorkPercent ?? this.deepWorkPercent,
      focusStreak: focusStreak ?? this.focusStreak,
      moodStability: moodStability ?? this.moodStability,
      burnoutRisk: burnoutRisk ?? this.burnoutRisk,
      dailyStudyHours: dailyStudyHours ?? this.dailyStudyHours,
      lastSevenDaysMood: lastSevenDaysMood ?? this.lastSevenDaysMood,
      lastSevenDaysFocus: lastSevenDaysFocus ?? this.lastSevenDaysFocus,
      focusHours: focusHours ?? this.focusHours,
      moodScores: moodScores ?? this.moodScores,
      deepWorkPercentage: deepWorkPercentage ?? this.deepWorkPercentage,
      completedTasks: completedTasks ?? this.completedTasks,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory UserAnalytics.fromJson(Map<String, dynamic> json) {
    return UserAnalytics(
      userId: json['userId'] as String,
      totalFocusHours: json['totalFocusHours'] as int? ?? 0,
      deepWorkPercent: json['deepWorkPercent'] as int? ?? 0,
      focusStreak: json['focusStreak'] as int? ?? 0,
      moodStability: (json['moodStability'] as num?)?.toDouble() ?? 100,
      burnoutRisk: json['burnoutRisk'] as int? ?? 0,
      dailyStudyHours: json['dailyStudyHours'] as int? ?? 0,
      lastSevenDaysMood: List<int>.from(
        json['lastSevenDaysMood'] as List? ?? [],
      ),
      lastSevenDaysFocus: List<int>.from(
        json['lastSevenDaysFocus'] as List? ?? [],
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalFocusHours': totalFocusHours,
      'deepWorkPercent': deepWorkPercent,
      'focusStreak': focusStreak,
      'moodStability': moodStability,
      'burnoutRisk': burnoutRisk,
      'dailyStudyHours': dailyStudyHours,
      'lastSevenDaysMood': lastSevenDaysMood,
      'lastSevenDaysFocus': lastSevenDaysFocus,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class BurnoutAlert {
  final String message;
  final String severity; // 'low', 'medium', 'high'
  final List<String>? suggestedActions;
  final DateTime detectedAt;

  BurnoutAlert({
    required this.message,
    required this.severity,
    this.suggestedActions,
    required this.detectedAt,
  });

  bool get isHighSeverity => severity == 'high';

  bool get isMediumSeverity => severity == 'medium';
}
