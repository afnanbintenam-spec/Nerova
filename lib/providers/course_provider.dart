import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../services/api_client.dart';
import 'task_provider.dart';

class CourseListState {
  final List<Course> courses;
  final bool isLoading;
  final String? error;
  final String sortBy; // 'name', 'progress', 'urgency'

  CourseListState({
    this.courses = const [],
    this.isLoading = false,
    this.error,
    this.sortBy = 'name',
  });

  List<Course> get sortedCourses {
    final list = [...courses];
    switch (sortBy) {
      case 'progress':
        list.sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
        break;
      case 'urgency':
        list.sort((a, b) {
          if (a.nextExamDate == null && b.nextExamDate == null) return 0;
          if (a.nextExamDate == null) return 1;
          if (b.nextExamDate == null) return -1;
          return a.nextExamDate!.compareTo(b.nextExamDate!);
        });
        break;
      default:
        list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  CourseListState copyWith({
    List<Course>? courses,
    bool? isLoading,
    String? error,
    String? sortBy,
  }) {
    return CourseListState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class CourseNotifier extends StateNotifier<CourseListState> {
  final ApiClient _apiClient;

  CourseNotifier(this._apiClient) : super(CourseListState()) {
    loadCourses();
  }

  Future<void> loadCourses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get('/courses');
      final courses =
          (response['courses'] as List?)
              ?.map((c) => Course.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [];
      state = state.copyWith(courses: courses, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load courses: $e',
      );
      _loadMockCourses();
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      await _apiClient.post('/courses', body: course.toJson());
      state = state.copyWith(courses: [...state.courses, course]);
    } catch (e) {
      state = state.copyWith(error: 'Failed to add course: $e');
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      await _apiClient.put('/courses/${course.id}', body: course.toJson());
      state = state.copyWith(
        courses: state.courses
            .map((c) => c.id == course.id ? course : c)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to update course: $e');
    }
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void _loadMockCourses() {
    final now = DateTime.now();
    final mockCourses = [
      Course(
        id: '1',
        name: 'Mathematics 101',
        code: 'MATH101',
        instructor: 'Dr. Smith',
        progressPercent: 65,
        weakTopics: ['Integration', 'Differential Equations'],
        nextExamDate: now.add(const Duration(days: 14)),
        suggestedReviewMinutes: 120,
        topics: [
          CourseTopic(
            id: '1',
            name: 'Algebra',
            completionPercent: 100,
            isWeak: false,
          ),
          CourseTopic(
            id: '2',
            name: 'Integration',
            completionPercent: 40,
            isWeak: true,
          ),
          CourseTopic(
            id: '3',
            name: 'Differential Equations',
            completionPercent: 50,
            isWeak: true,
          ),
        ],
        createdAt: now,
      ),
      Course(
        id: '2',
        name: 'Physics 201',
        code: 'PHYS201',
        instructor: 'Prof. Johnson',
        progressPercent: 48,
        weakTopics: ['Thermodynamics', 'Quantum Mechanics'],
        nextExamDate: now.add(const Duration(days: 5)),
        suggestedReviewMinutes: 180,
        topics: [
          CourseTopic(
            id: '1',
            name: 'Mechanics',
            completionPercent: 100,
            isWeak: false,
          ),
          CourseTopic(
            id: '2',
            name: 'Thermodynamics',
            completionPercent: 30,
            isWeak: true,
          ),
          CourseTopic(
            id: '3',
            name: 'Quantum Mechanics',
            completionPercent: 20,
            isWeak: true,
          ),
        ],
        createdAt: now,
      ),
      Course(
        id: '3',
        name: 'Chemistry 150',
        code: 'CHEM150',
        instructor: 'Dr. Brown',
        progressPercent: 82,
        weakTopics: [],
        nextExamDate: now.add(const Duration(days: 21)),
        suggestedReviewMinutes: 60,
        topics: [
          CourseTopic(
            id: '1',
            name: 'Organic Chemistry',
            completionPercent: 95,
            isWeak: false,
          ),
          CourseTopic(
            id: '2',
            name: 'Inorganic Chemistry',
            completionPercent: 80,
            isWeak: false,
          ),
        ],
        createdAt: now,
      ),
    ];
    state = state.copyWith(courses: mockCourses, isLoading: false);
  }
}

final courseListProvider =
    StateNotifierProvider<CourseNotifier, CourseListState>((ref) {
      return CourseNotifier(ref.watch(apiClientProvider));
    });
