import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vault_note.dart';
import '../services/api_client.dart';
import 'task_provider.dart';

class VaultState {
  final List<VaultNote> notes;
  final bool isLoading;
  final String? error;
  final String viewMode; // 'grid', 'list'
  final String
  filterType; // 'all', 'ai_summary', 'ai_quiz', 'ai_flashcard', 'user_note'
  final String? filterCourse;
  final String searchQuery;

  VaultState({
    this.notes = const [],
    this.isLoading = false,
    this.error,
    this.viewMode = 'grid',
    this.filterType = 'all',
    this.filterCourse,
    this.searchQuery = '',
  });

  List<VaultNote> get filteredNotes {
    var filtered = [...notes];

    // Filter by type
    if (filterType != 'all') {
      filtered = filtered.where((n) => n.sourceType == filterType).toList();
    }

    // Filter by course
    if (filterCourse != null) {
      filtered = filtered.where((n) => n.courseId == filterCourse).toList();
    }

    // Search
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (n) =>
                n.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                n.content.toLowerCase().contains(searchQuery.toLowerCase()) ||
                n.tags.any(
                  (t) => t.toLowerCase().contains(searchQuery.toLowerCase()),
                ),
          )
          .toList();
    }

    // Sort (pinned first, then by date)
    filtered.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  VaultState copyWith({
    List<VaultNote>? notes,
    bool? isLoading,
    String? error,
    String? viewMode,
    String? filterType,
    String? filterCourse,
    String? searchQuery,
  }) {
    return VaultState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      viewMode: viewMode ?? this.viewMode,
      filterType: filterType ?? this.filterType,
      filterCourse: filterCourse ?? this.filterCourse,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class VaultNotifier extends StateNotifier<VaultState> {
  final ApiClient _apiClient;

  VaultNotifier(this._apiClient) : super(VaultState()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get('/vault');
      final notes =
          (response['notes'] as List?)
              ?.map((n) => VaultNote.fromJson(n as Map<String, dynamic>))
              .toList() ??
          [];
      state = state.copyWith(notes: notes, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notes: $e',
      );
      _loadMockNotes();
    }
  }

  Future<void> addNote(VaultNote note) async {
    try {
      await _apiClient.post('/vault', body: note.toJson());
      state = state.copyWith(notes: [...state.notes, note]);
    } catch (e) {
      state = state.copyWith(error: 'Failed to add note: $e');
    }
  }

  Future<void> updateNote(VaultNote note) async {
    try {
      await _apiClient.put('/vault/${note.id}', body: note.toJson());
      state = state.copyWith(
        notes: state.notes.map((n) => n.id == note.id ? note : n).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _apiClient.delete('/vault/$id');
      state = state.copyWith(
        notes: state.notes.where((n) => n.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete note: $e');
    }
  }

  void togglePin(String id) {
    final note = state.notes.firstWhere((n) => n.id == id);
    updateNote(note.copyWith(isPinned: !note.isPinned));
  }

  void setViewMode(String mode) {
    state = state.copyWith(viewMode: mode);
  }

  void setFilterType(String type) {
    state = state.copyWith(filterType: type);
  }

  void setFilterCourse(String? courseId) {
    state = state.copyWith(filterCourse: courseId);
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void _loadMockNotes() {
    final now = DateTime.now();
    final mockNotes = [
      VaultNote(
        id: '1',
        title: 'Integration Techniques',
        content: 'Key methods: substitution, by parts, partial fractions',
        courseId: '1',
        tags: ['math', 'calculus', 'integration'],
        isPinned: true,
        sourceType: 'ai_summary',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      VaultNote(
        id: '2',
        title: 'Newton\'s Laws Quiz',
        content: 'Q1: Define inertia...\nQ2: What is equilibrium?',
        courseId: '2',
        tags: ['physics', 'mechanics'],
        isPinned: false,
        sourceType: 'ai_quiz',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      VaultNote(
        id: '3',
        title: 'Thermodynamics Flashcards',
        content: 'Card 1: Q: What is entropy? A: Measure of disorder',
        courseId: '2',
        tags: ['physics', 'thermodynamics'],
        isPinned: false,
        sourceType: 'ai_flashcard',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
    state = state.copyWith(notes: mockNotes, isLoading: false);
  }
}

final vaultProvider = StateNotifierProvider<VaultNotifier, VaultState>((ref) {
  return VaultNotifier(ref.watch(apiClientProvider));
});
