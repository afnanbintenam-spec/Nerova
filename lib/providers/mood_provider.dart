import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mood.dart';
import '../services/api_client.dart';
import '../providers/task_provider.dart';

// Mood service provider
final moodServiceProvider = Provider<MoodService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MoodService(apiClient);
});

class MoodService {
  final ApiClient _apiClient;

  MoodService(this._apiClient);

  Future<List<Mood>> getMoods({int? days}) async {
    try {
      final endpoint = days != null ? '/moods?days=$days' : '/moods';
      final response = await _apiClient.get(endpoint);
      final List<dynamic> moodsJson = response['moods'] ?? response;
      return moodsJson.map((json) => Mood.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load moods: $e');
    }
  }

  Future<Mood> createMood({
    required String mood,
    required int energy,
    required int stress,
    String? note,
    List<String> activities = const [],
  }) async {
    try {
      final response = await _apiClient.post(
        '/moods',
        body: {
          'mood': mood,
          'energy': energy,
          'stress': stress,
          'note': note,
          'activities': activities,
        },
      );
      return Mood.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create mood: $e');
    }
  }

  // Mock implementation for development
  Future<List<Mood>> getMockMoods() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    return [
      Mood(
        id: '1',
        mood: 'happy',
        energy: 4,
        stress: 2,
        note: 'Great study session today!',
        activities: ['studying', 'exercising'],
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      Mood(
        id: '2',
        mood: 'stressed',
        energy: 3,
        stress: 4,
        note: 'Lots of assignments due',
        activities: ['studying', 'working'],
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      Mood(
        id: '3',
        mood: 'energetic',
        energy: 5,
        stress: 2,
        note: 'Good sleep last night',
        activities: ['exercising', 'socializing'],
        timestamp: now.subtract(const Duration(days: 2)),
      ),
      Mood(
        id: '4',
        mood: 'tired',
        energy: 2,
        stress: 3,
        activities: ['studying'],
        timestamp: now.subtract(const Duration(days: 3)),
      ),
      Mood(
        id: '5',
        mood: 'neutral',
        energy: 3,
        stress: 3,
        note: 'Regular day',
        activities: ['studying', 'relaxing'],
        timestamp: now.subtract(const Duration(days: 4)),
      ),
      Mood(
        id: '6',
        mood: 'happy',
        energy: 4,
        stress: 1,
        note: 'Finished major project!',
        activities: ['studying', 'socializing'],
        timestamp: now.subtract(const Duration(days: 5)),
      ),
      Mood(
        id: '7',
        mood: 'stressed',
        energy: 2,
        stress: 5,
        note: 'Exam week pressure',
        activities: ['studying'],
        timestamp: now.subtract(const Duration(days: 6)),
      ),
    ];
  }
}

// Mood state
class MoodState {
  final List<Mood> moods;
  final bool isLoading;
  final String? error;

  MoodState({this.moods = const [], this.isLoading = false, this.error});

  MoodState copyWith({List<Mood>? moods, bool? isLoading, String? error}) {
    return MoodState(
      moods: moods ?? this.moods,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Get average energy over last 7 days
  double get averageEnergy {
    if (moods.isEmpty) return 0;
    final recent = moods.take(7).toList();
    return recent.fold(0, (sum, mood) => sum + mood.energy) / recent.length;
  }

  // Get average stress over last 7 days
  double get averageStress {
    if (moods.isEmpty) return 0;
    final recent = moods.take(7).toList();
    return recent.fold(0, (sum, mood) => sum + mood.stress) / recent.length;
  }

  // Get most common mood
  String? get dominantMood {
    if (moods.isEmpty) return null;
    final moodCounts = <String, int>{};
    for (var mood in moods.take(7)) {
      moodCounts[mood.mood] = (moodCounts[mood.mood] ?? 0) + 1;
    }
    return moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

// Mood notifier
class MoodNotifier extends StateNotifier<MoodState> {
  final MoodService _moodService;

  MoodNotifier(this._moodService) : super(MoodState()) {
    loadMoods();
  }

  Future<void> loadMoods({int? days}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Use mock data for now
      final moods = await _moodService.getMockMoods();

      // Sort by timestamp descending
      moods.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      state = state.copyWith(moods: moods, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load moods: ${e.toString()}',
      );
    }
  }

  Future<bool> addMood({
    required String mood,
    required int energy,
    required int stress,
    String? note,
    List<String> activities = const [],
  }) async {
    try {
      // For now, create mood locally
      final newMood = Mood(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mood: mood,
        energy: energy,
        stress: stress,
        note: note,
        activities: activities,
        timestamp: DateTime.now(),
      );

      final updatedMoods = [newMood, ...state.moods];
      state = state.copyWith(moods: updatedMoods);
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to add mood: ${e.toString()}');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Mood provider
final moodProvider = StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  final moodService = ref.watch(moodServiceProvider);
  return MoodNotifier(moodService);
});
