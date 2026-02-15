class Exam {
  final String id;
  final String title;
  final String? course;
  final DateTime examDate;
  final String subject;
  final String? description;
  final double? readinessScore;
  final List<String> linkedTaskIds;
  final DateTime createdAt;

  Exam({
    required this.id,
    required this.title,
    this.course,
    required this.examDate,
    required this.subject,
    this.description,
    this.readinessScore,
    this.linkedTaskIds = const [],
    required this.createdAt,
  });

  Duration get daysUntilExam => examDate.difference(DateTime.now());

  bool get isUpcoming => daysUntilExam.inDays > 0;

  bool get isUrgent => daysUntilExam.inDays <= 7;

  bool get isHighRisk => (readinessScore ?? 0) < 40;

  bool get isMediumRisk => (readinessScore ?? 0) < 70;

  Exam copyWith({
    String? id,
    String? title,
    String? course,
    DateTime? examDate,
    String? subject,
    String? description,
    double? readinessScore,
    List<String>? linkedTaskIds,
    DateTime? createdAt,
  }) {
    return Exam(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      examDate: examDate ?? this.examDate,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      readinessScore: readinessScore ?? this.readinessScore,
      linkedTaskIds: linkedTaskIds ?? this.linkedTaskIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      title: json['title'] as String,
      course: json['course'] as String?,
      examDate: DateTime.parse(json['examDate'] as String),
      subject: json['subject'] as String,
      description: json['description'] as String?,
      readinessScore: (json['readinessScore'] as num?)?.toDouble(),
      linkedTaskIds: List<String>.from(json['linkedTaskIds'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'examDate': examDate.toIso8601String(),
      'subject': subject,
      'description': description,
      'readinessScore': readinessScore,
      'linkedTaskIds': linkedTaskIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
