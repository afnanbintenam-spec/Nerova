import '../models/task.dart';
import 'api_client.dart';

/// Service for task-related API calls
class TaskService {
  final ApiClient _apiClient;

  TaskService(this._apiClient);

  /// Get all tasks
  Future<List<Task>> getTasks() async {
    try {
      final response = await _apiClient.get('/tasks');
      final List<dynamic> tasksJson = response['tasks'] ?? response;
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  /// Get a single task by ID
  Future<Task> getTask(String id) async {
    try {
      final response = await _apiClient.get('/tasks/$id');
      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load task: $e');
    }
  }

  /// Create a new task
  Future<Task> createTask({
    required String title,
    String? description,
    String? course,
    DateTime? dueDate,
    String priority = 'Medium',
    String? category,
  }) async {
    try {
      final response = await _apiClient.post(
        '/tasks',
        body: {
          'title': title,
          'description': description,
          'course': course,
          'dueDate': dueDate?.toIso8601String(),
          'priority': priority,
          'category': category,
        },
      );
      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  /// Update an existing task
  Future<Task> updateTask(
    String id, {
    String? title,
    String? description,
    String? course,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
    String? category,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (course != null) body['course'] = course;
      if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();
      if (priority != null) body['priority'] = priority;
      if (isCompleted != null) body['isCompleted'] = isCompleted;
      if (category != null) body['category'] = category;

      final response = await _apiClient.put('/tasks/$id', body: body);
      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// Toggle task completion status
  Future<Task> toggleTask(String id, bool isCompleted) async {
    try {
      final response = await _apiClient.patch(
        '/tasks/$id',
        body: {'isCompleted': isCompleted},
      );
      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to toggle task: $e');
    }
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    try {
      await _apiClient.delete('/tasks/$id');
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// Get tasks filtered by status
  Future<List<Task>> getTasksByStatus({
    bool? isCompleted,
    bool? isOverdue,
    bool? isDueToday,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (isCompleted != null)
        queryParams['completed'] = isCompleted.toString();
      if (isOverdue != null) queryParams['overdue'] = isOverdue.toString();
      if (isDueToday != null) queryParams['today'] = isDueToday.toString();

      final query = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      final endpoint = query.isEmpty ? '/tasks' : '/tasks?$query';

      final response = await _apiClient.get(endpoint);
      final List<dynamic> tasksJson = response['tasks'] ?? response;
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load filtered tasks: $e');
    }
  }

  /// Mock implementation for development (returns sample tasks)
  Future<List<Task>> getMockTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    return [
      Task(
        id: '1',
        title: 'Chemistry Quiz Prep',
        description: 'Review chapters 5-7, focus on organic compounds',
        course: 'CHEM 101',
        dueDate: DateTime(now.year, now.month, now.day, 18, 0),
        priority: 'High',
        isCompleted: false,
        category: 'Study',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: '2',
        title: 'Algorithm Notes Review',
        description: 'Go through sorting algorithms and time complexity',
        course: 'CSE 220',
        dueDate: DateTime(now.year, now.month, now.day + 1, 9, 0),
        priority: 'Medium',
        isCompleted: false,
        category: 'Study',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: '3',
        title: 'English Essay Outline',
        description: 'Create detailed outline for literary analysis essay',
        course: 'ENG 104',
        dueDate: DateTime(now.year, now.month, now.day + 3, 17, 0),
        priority: 'Low',
        isCompleted: false,
        category: 'Assignment',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      Task(
        id: '4',
        title: 'Math Problem Set',
        description: 'Complete problems 1-20 from chapter 8',
        course: 'MATH 201',
        dueDate: DateTime(now.year, now.month, now.day - 1, 23, 59),
        priority: 'High',
        isCompleted: false,
        category: 'Assignment',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),
      Task(
        id: '5',
        title: 'Lab Report Submission',
        description: 'Finalize and submit physics lab report',
        course: 'PHYS 150',
        dueDate: DateTime(now.year, now.month, now.day, 14, 0),
        priority: 'High',
        isCompleted: true,
        category: 'Lab',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
    ];
  }
}
