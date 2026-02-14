import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sync_queue_item.dart';
import '../providers/task_provider.dart';
import 'connectivity_service.dart';
import 'api_client.dart';

class SyncService {
  static const String _boxName = 'sync_queue';
  static const int _maxRetries = 3;

  final ApiClient _apiClient;
  final ConnectivityService _connectivityService;
  Box<SyncQueueItem>? _box;
  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService(this._apiClient, this._connectivityService) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<SyncQueueItem>(_boxName);

    // Listen for connectivity changes
    _connectivityService.statusStream.listen((isOnline) {
      if (isOnline && !_isSyncing) {
        syncPendingOperations();
      }
    });

    // Periodic sync every 5 minutes
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (_connectivityService.isOnline && !_isSyncing) {
        syncPendingOperations();
      }
    });
  }

  Future<void> addToQueue(SyncQueueItem item) async {
    await _box?.put(item.id, item);

    // Try to sync immediately if online
    if (_connectivityService.isOnline && !_isSyncing) {
      syncPendingOperations();
    }
  }

  Future<void> syncPendingOperations() async {
    if (_isSyncing || _box == null || _box!.isEmpty) return;

    _isSyncing = true;

    try {
      final items = _box!.values.toList();

      for (final item in items) {
        if (!_connectivityService.isOnline) break;

        try {
          await _processItem(item);
          await _box!.delete(item.id);
        } catch (e) {
          // Update retry count
          item.retryCount++;
          item.lastAttempt = DateTime.now();
          item.errorMessage = e.toString();

          if (item.retryCount >= _maxRetries) {
            // Max retries reached, remove from queue
            await _box!.delete(item.id);
            print('Max retries reached for ${item.id}, removing from queue');
          } else {
            // Save updated item back to box
            await _box!.put(item.id, item);
          }
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processItem(SyncQueueItem item) async {
    switch (item.operation) {
      case SyncOperation.create:
        await _apiClient.post(item.endpoint);
        break;
      case SyncOperation.update:
        await _apiClient.put(item.endpoint);
        break;
      case SyncOperation.delete:
        await _apiClient.delete(item.endpoint);
        break;
    }
  }

  int get pendingCount => _box?.length ?? 0;

  bool get hasPendingOperations => pendingCount > 0;

  Future<void> clearQueue() async {
    await _box?.clear();
  }

  void dispose() {
    _syncTimer?.cancel();
    _box?.close();
  }
}

// Provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final service = SyncService(apiClient, connectivity);
  ref.onDispose(() => service.dispose());
  return service;
});

// Pending operations count provider
final pendingSyncCountProvider = Provider<int>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.pendingCount;
});
