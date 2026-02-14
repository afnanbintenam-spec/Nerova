class Task {
  final String id;
  final String title;
  final String? description;
  final String? course;
  final DateTime? dueDate;
  final String priority; // 'High', 'Medium', 'Low'
  final bool isCompleted;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.course,
    this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      course: json['course'] as String?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: json['priority'] as String? ?? 'Medium',
      isCompleted: json['isCompleted'] as bool? ?? false,
      category: json['category'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'course': course,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? course,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      course: course ?? this.course,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  // Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  // Check if task is upcoming (within 7 days)
  bool get isUpcoming {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return dueDate!.isAfter(now) && dueDate!.isBefore(weekFromNow);
  }

  // Format due date for display
  String get formattedDueDate {
    if (dueDate == null) return 'No due date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    if (taskDate == today) {
      return 'Today ${_formatTime(dueDate!)}';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow ${_formatTime(dueDate!)}';
    } else if (taskDate.isBefore(tomorrow.add(const Duration(days: 6)))) {
      return '${_getDayName(taskDate.weekday)} ${_formatTime(dueDate!)}';
    } else {
      return '${taskDate.month}/${taskDate.day} ${_formatTime(dueDate!)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
