class Course {
  final String id;
  final String name;
  final String code;
  final String instructor;
  final double progressPercent;
  final List<String> weakTopics;
  final DateTime? nextExamDate;
  final int suggestedReviewMinutes;
  final List<CourseTopic> topics;
  final DateTime createdAt;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.instructor,
    this.progressPercent = 0,
    this.weakTopics = const [],
    this.nextExamDate,
    this.suggestedReviewMinutes = 0,
    this.topics = const [],
    required this.createdAt,
  });

  int get weakTopicCount => weakTopics.length;

  Course copyWith({
    String? id,
    String? name,
    String? code,
    String? instructor,
    double? progressPercent,
    List<String>? weakTopics,
    DateTime? nextExamDate,
    int? suggestedReviewMinutes,
    List<CourseTopic>? topics,
    DateTime? createdAt,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      instructor: instructor ?? this.instructor,
      progressPercent: progressPercent ?? this.progressPercent,
      weakTopics: weakTopics ?? this.weakTopics,
      nextExamDate: nextExamDate ?? this.nextExamDate,
      suggestedReviewMinutes:
          suggestedReviewMinutes ?? this.suggestedReviewMinutes,
      topics: topics ?? this.topics,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      instructor: json['instructor'] as String,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0,
      weakTopics: List<String>.from(json['weakTopics'] as List? ?? []),
      nextExamDate: json['nextExamDate'] != null
          ? DateTime.parse(json['nextExamDate'] as String)
          : null,
      suggestedReviewMinutes: json['suggestedReviewMinutes'] as int? ?? 0,
      topics:
          (json['topics'] as List?)
              ?.map((t) => CourseTopic.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'instructor': instructor,
      'progressPercent': progressPercent,
      'weakTopics': weakTopics,
      'nextExamDate': nextExamDate?.toIso8601String(),
      'suggestedReviewMinutes': suggestedReviewMinutes,
      'topics': topics.map((t) => t.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CourseTopic {
  final String id;
  final String name;
  final double completionPercent;
  final bool isWeak;
  final List<String> resources;

  CourseTopic({
    required this.id,
    required this.name,
    this.completionPercent = 0,
    this.isWeak = false,
    this.resources = const [],
  });

  CourseTopic copyWith({
    String? id,
    String? name,
    double? completionPercent,
    bool? isWeak,
    List<String>? resources,
  }) {
    return CourseTopic(
      id: id ?? this.id,
      name: name ?? this.name,
      completionPercent: completionPercent ?? this.completionPercent,
      isWeak: isWeak ?? this.isWeak,
      resources: resources ?? this.resources,
    );
  }

  factory CourseTopic.fromJson(Map<String, dynamic> json) {
    return CourseTopic(
      id: json['id'] as String,
      name: json['name'] as String,
      completionPercent: (json['completionPercent'] as num?)?.toDouble() ?? 0,
      isWeak: json['isWeak'] as bool? ?? false,
      resources: List<String>.from(json['resources'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completionPercent': completionPercent,
      'isWeak': isWeak,
      'resources': resources,
    };
  }
}
