import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String settingsBox = 'settings';

  Future<void> init() async {
    await Hive.initFlutter();

    // Open box for settings storage
    await Hive.openBox(settingsBox);
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
    await Hive.box(settingsBox).clear();
  }
}
