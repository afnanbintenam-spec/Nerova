import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task.dart';
import '../services/api_client.dart';
import '../services/task_service.dart';

// Provider for API client
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Provider for task service
final taskServiceProvider = Provider<TaskService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TaskService(apiClient);
});

// State for task list
class TaskListState {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;
  final String filter; // 'all', 'today', 'overdue', 'upcoming', 'completed'

  TaskListState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.filter = 'all',
  });

  TaskListState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
    String? filter,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
    );
  }

  // Get filtered tasks based on current filter
  List<Task> get filteredTasks {
    switch (filter) {
      case 'today':
        return tasks
            .where((task) => task.isDueToday && !task.isCompleted)
            .toList();
      case 'overdue':
        return tasks.where((task) => task.isOverdue).toList();
      case 'upcoming':
        return tasks.where((task) => task.isUpcoming).toList();
      case 'completed':
        return tasks.where((task) => task.isCompleted).toList();
      case 'all':
      default:
        return tasks;
    }
  }

  // Get task counts for different categories
  int get todayCount =>
      tasks.where((task) => task.isDueToday && !task.isCompleted).length;
  int get overdueCount => tasks.where((task) => task.isOverdue).length;
  int get upcomingCount => tasks.where((task) => task.isUpcoming).length;
  int get completedCount => tasks.where((task) => task.isCompleted).length;
}

// Task list notifier
class TaskListNotifier extends StateNotifier<TaskListState> {
  final TaskService _taskService;

  TaskListNotifier(this._taskService) : super(TaskListState()) {
    loadTasks();
  }

  /// Load all tasks
  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Use mock tasks for now (replace with _taskService.getTasks() when backend is ready)
      final tasks = await _taskService.getMockTasks();

      // Sort tasks: overdue first, then by due date
      tasks.sort((a, b) {
        if (a.isOverdue && !b.isOverdue) return -1;
        if (!a.isOverdue && b.isOverdue) return 1;
        if (a.dueDate == null && b.dueDate != null) return 1;
        if (a.dueDate != null && b.dueDate == null) return -1;
        if (a.dueDate == null && b.dueDate == null) return 0;
        return a.dueDate!.compareTo(b.dueDate!);
      });

      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load tasks: ${e.toString()}',
      );
    }
  }

  /// Set filter
  void setFilter(String filter) {
    state = state.copyWith(filter: filter);
  }

  /// Add a new task
  Future<bool> addTask({
    required String title,
    String? description,
    String? course,
    DateTime? dueDate,
    String priority = 'Medium',
    String? category,
  }) async {
    try {
      // For now, create task locally (replace with API call when backend is ready)
      final now = DateTime.now();
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        course: course,
        dueDate: dueDate,
        priority: priority,
        category: category,
        createdAt: now,
        updatedAt: now,
      );

      final updatedTasks = [...state.tasks, newTask];
      state = state.copyWith(tasks: updatedTasks);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to add task: ${e.toString()}');
      return false;
    }
  }

  /// Update an existing task
  Future<bool> updateTask(
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
      final taskIndex = state.tasks.indexWhere((t) => t.id == id);
      if (taskIndex == -1) {
        state = state.copyWith(error: 'Task not found');
        return false;
      }

      final updatedTask = state.tasks[taskIndex].copyWith(
        title: title,
        description: description,
        course: course,
        dueDate: dueDate,
        priority: priority,
        isCompleted: isCompleted,
        category: category,
        updatedAt: DateTime.now(),
      );

      final updatedTasks = [...state.tasks];
      updatedTasks[taskIndex] = updatedTask;
      state = state.copyWith(tasks: updatedTasks);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to update task: ${e.toString()}');
      return false;
    }
  }

  /// Toggle task completion
  Future<bool> toggleTask(String id) async {
    try {
      final taskIndex = state.tasks.indexWhere((t) => t.id == id);
      if (taskIndex == -1) return false;

      final task = state.tasks[taskIndex];
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      );

      final updatedTasks = [...state.tasks];
      updatedTasks[taskIndex] = updatedTask;
      state = state.copyWith(tasks: updatedTasks);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to toggle task: ${e.toString()}');
      return false;
    }
  }

  /// Delete a task
  Future<bool> deleteTask(String id) async {
    try {
      final updatedTasks = state.tasks.where((t) => t.id != id).toList();
      state = state.copyWith(tasks: updatedTasks);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete task: ${e.toString()}');
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for task list
final taskListProvider = StateNotifierProvider<TaskListNotifier, TaskListState>(
  (ref) {
    final taskService = ref.watch(taskServiceProvider);
    return TaskListNotifier(taskService);
  },
);
