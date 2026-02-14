class Mood {
  final String id;
  final String
  mood; // 'happy', 'neutral', 'sad', 'stressed', 'energetic', 'tired'
  final int energy; // 1-5
  final int stress; // 1-5
  final String? note;
  final List<String>
  activities; // ['studying', 'exercising', 'socializing', etc.]
  final DateTime timestamp;

  Mood({
    required this.id,
    required this.mood,
    required this.energy,
    required this.stress,
    this.note,
    this.activities = const [],
    required this.timestamp,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      id: json['id'] as String,
      mood: json['mood'] as String,
      energy: json['energy'] as int,
      stress: json['stress'] as int,
      note: json['note'] as String?,
      activities:
          (json['activities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood,
      'energy': energy,
      'stress': stress,
      'note': note,
      'activities': activities,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Mood copyWith({
    String? id,
    String? mood,
    int? energy,
    int? stress,
    String? note,
    List<String>? activities,
    DateTime? timestamp,
  }) {
    return Mood(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      stress: stress ?? this.stress,
      note: note ?? this.note,
      activities: activities ?? this.activities,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // Get emoji for mood
  String get emoji {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'stressed':
        return '😰';
      case 'energetic':
        return '⚡';
      case 'tired':
        return '😴';
      case 'neutral':
      default:
        return '😐';
    }
  }

  // Get color for mood
  String get colorHex {
    switch (mood) {
      case 'happy':
        return '#4BC6B9'; // Mint
      case 'sad':
        return '#5B6DFF'; // Electric
      case 'stressed':
        return '#F07167'; // Rose
      case 'energetic':
        return '#F9B233'; // Amber
      case 'tired':
        return '#708090'; // Slate
      case 'neutral':
      default:
        return '#10253E'; // Navy
    }
  }
}
