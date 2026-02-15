class VaultNote {
  final String id;
  final String title;
  final String content;
  final String? courseId;
  final List<String> tags;
  final bool isPinned;
  final String
  sourceType; // 'ai_summary', 'ai_quiz', 'ai_flashcard', 'user_note'
  final DateTime createdAt;
  final DateTime? updatedAt;

  VaultNote({
    required this.id,
    required this.title,
    required this.content,
    this.courseId,
    this.tags = const [],
    this.isPinned = false,
    this.sourceType = 'user_note',
    required this.createdAt,
    this.updatedAt,
  });

  VaultNote copyWith({
    String? id,
    String? title,
    String? content,
    String? courseId,
    List<String>? tags,
    bool? isPinned,
    String? sourceType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VaultNote(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      courseId: courseId ?? this.courseId,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      sourceType: sourceType ?? this.sourceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory VaultNote.fromJson(Map<String, dynamic> json) {
    return VaultNote(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      courseId: json['courseId'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      isPinned: json['isPinned'] as bool? ?? false,
      sourceType: json['sourceType'] as String? ?? 'user_note',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'courseId': courseId,
      'tags': tags,
      'isPinned': isPinned,
      'sourceType': sourceType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
