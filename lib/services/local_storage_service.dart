import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/mood.dart';

class LocalStorageService {
  static const String tasksBox = 'tasks';
  static const String moodsBox = 'moods';
  static const String syncQueueBox = 'sync_queue';
  static const String settingsBox = 'settings';

  Future<void> init() async {
    await Hive.initFlutter();

    // Open boxes for data storage
    await Hive.openBox(tasksBox);
    await Hive.openBox(moodsBox);
    await Hive.openBox(syncQueueBox);
    await Hive.openBox(settingsBox);
  }

  // ===== TASK OPERATIONS =====
  Future<void> saveTasks(List<Task> tasks) async {
    final box = Hive.box(tasksBox);
    final taskMap = {for (var task in tasks) task.id: task.toJson()};
    await box.putAll(taskMap);
  }

  Future<void> saveTask(Task task) async {
    final box = Hive.box(tasksBox);
    await box.put(task.id, task.toJson());
  }

  Future<List<Task>> getTasks() async {
    final box = Hive.box(tasksBox);
    return box.values
        .map((json) => Task.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<Task?> getTask(String id) async {
    final box = Hive.box(tasksBox);
    final json = box.get(id);
    if (json == null) return null;
    return Task.fromJson(Map<String, dynamic>.from(json));
  }

  Future<void> deleteTask(String id) async {
    final box = Hive.box(tasksBox);
    await box.delete(id);
  }

  // ===== MOOD OPERATIONS =====
  Future<void> saveMoods(List<Mood> moods) async {
    final box = Hive.box(moodsBox);
    final moodMap = {for (var mood in moods) mood.id: mood.toJson()};
    await box.putAll(moodMap);
  }

  Future<void> saveMood(Mood mood) async {
    final box = Hive.box(moodsBox);
    await box.put(mood.id, mood.toJson());
  }

  Future<List<Mood>> getMoods() async {
    final box = Hive.box(moodsBox);
    return box.values
        .map((json) => Mood.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> deleteMood(String id) async {
    final box = Hive.box(moodsBox);
    await box.delete(id);
  }

  // ===== SYNC QUEUE OPERATIONS =====
  Future<void> addToSyncQueue(Map<String, dynamic> operation) async {
    final box = Hive.box(syncQueueBox);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await box.put(timestamp.toString(), operation);
  }

  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    final box = Hive.box(syncQueueBox);
    return box.values.map((json) => Map<String, dynamic>.from(json)).toList();
  }

  Future<void> removeSyncQueueItem(String key) async {
    final box = Hive.box(syncQueueBox);
    await box.delete(key);
  }

  Future<void> clearSyncQueue() async {
    final box = Hive.box(syncQueueBox);
    await box.clear();
  }

  // ===== SETTINGS OPERATIONS =====
  Future<void> saveSetting(String key, dynamic value) async {
    final box = Hive.box(settingsBox);
    await box.put(key, value);
  }

  Future<T?> getSetting<T>(String key) async {
    final box = Hive.box(settingsBox);
    return box.get(key) as T?;
  }

  Future<void> clearAllData() async {
    await Hive.box(tasksBox).clear();
    await Hive.box(moodsBox).clear();
    await Hive.box(syncQueueBox).clear();
    await Hive.box(settingsBox).clear();
  }

  // Get last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    final timestamp = await getSetting<int>('last_sync_time');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // Save last sync timestamp
  Future<void> saveLastSyncTime(DateTime time) async {
    await saveSetting('last_sync_time', time.millisecondsSinceEpoch);
  }
}
