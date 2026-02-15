import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exam.dart';
import '../services/api_client.dart';
import 'task_provider.dart';

class ExamListState {
  final List<Exam> exams;
  final bool isLoading;
  final String? error;
  final String filter; // 'all', 'upcoming', 'urgent'

  ExamListState({
    this.exams = const [],
    this.isLoading = false,
    this.error,
    this.filter = 'all',
  });

  List<Exam> get filteredExams {
    switch (filter) {
      case 'upcoming':
        return exams.where((e) => e.isUpcoming).toList();
      case 'urgent':
        return exams.where((e) => e.isUrgent).toList();
      default:
        return exams;
    }
  }

  ExamListState copyWith({
    List<Exam>? exams,
    bool? isLoading,
    String? error,
    String? filter,
  }) {
    return ExamListState(
      exams: exams ?? this.exams,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
    );
  }
}

class ExamNotifier extends StateNotifier<ExamListState> {
  final ApiClient _apiClient;

  ExamNotifier(this._apiClient) : super(ExamListState()) {
    loadExams();
  }

  Future<void> loadExams() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get('/exams');
      final exams =
          (response['exams'] as List?)
              ?.map((e) => Exam.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      state = state.copyWith(exams: exams, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load exams: $e',
      );
      _loadMockExams();
    }
  }

  Future<void> addExam(Exam exam) async {
    try {
      await _apiClient.post('/exams', body: exam.toJson());
      state = state.copyWith(exams: [...state.exams, exam]);
    } catch (e) {
      state = state.copyWith(error: 'Failed to add exam: $e');
    }
  }

  Future<void> updateExam(Exam exam) async {
    try {
      await _apiClient.put('/exams/${exam.id}', body: exam.toJson());
      state = state.copyWith(
        exams: state.exams.map((e) => e.id == exam.id ? exam : e).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to update exam: $e');
    }
  }

  Future<void> deleteExam(String id) async {
    try {
      await _apiClient.delete('/exams/$id');
      state = state.copyWith(
        exams: state.exams.where((e) => e.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete exam: $e');
    }
  }

  void setFilter(String filter) {
    state = state.copyWith(filter: filter);
  }

  void _loadMockExams() {
    final now = DateTime.now();
    final mockExams = [
      Exam(
        id: '1',
        title: 'Mathematics Midterm',
        course: 'Mathematics 101',
        examDate: now.add(const Duration(days: 14)),
        subject: 'Algebra & Calculus',
        description: 'Covers chapters 1-5',
        readinessScore: 65,
        createdAt: now,
      ),
      Exam(
        id: '2',
        title: 'Physics Final',
        course: 'Physics 201',
        examDate: now.add(const Duration(days: 5)),
        subject: 'Mechanics & Thermodynamics',
        description: 'Comprehensive exam',
        readinessScore: 45,
        createdAt: now,
      ),
      Exam(
        id: '3',
        title: 'Chemistry Lab Exam',
        course: 'Chemistry 150',
        examDate: now.add(const Duration(days: 21)),
        subject: 'Organic Chemistry',
        description: 'Practical exam',
        readinessScore: 80,
        createdAt: now,
      ),
    ];
    state = state.copyWith(exams: mockExams, isLoading: false);
  }
}

final examListProvider = StateNotifierProvider<ExamNotifier, ExamListState>((
  ref,
) {
  return ExamNotifier(ref.watch(apiClientProvider));
});
