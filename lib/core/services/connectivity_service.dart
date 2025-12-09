import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    // Check initial connectivity
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = results.any((result) => result != ConnectivityResult.none);

    if (wasConnected != _isConnected) {
      _connectionController.add(_isConnected);
      debugPrint('Connectivity changed: $_isConnected');
    }
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
      return _isConnected;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectionController.close();
  }
}
