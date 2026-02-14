import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectivityController;
  bool _isOnline = true;

  Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final isOnline = result != ConnectivityResult.none;
      _isOnline = isOnline;
      _connectivityController?.add(isOnline);
    });
    return _connectivityController!.stream;
  }

  // Add alias for sync_service compatibility
  Stream<bool> get statusStream => connectivityStream;

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    final isConnected = result != ConnectivityResult.none;
    _isOnline = isConnected;
    return isConnected;
  }

  // Synchronous isOnline getter
  bool get isOnline => _isOnline;

  void dispose() {
    _connectivityController?.close();
  }
}

// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Provider for current connectivity status
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});
