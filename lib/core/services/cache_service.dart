import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const String _cacheBoxName = 'cache';
  static const String _imageCacheBoxName = 'image_cache';
  static const Duration _defaultCacheDuration = Duration(hours: 24);

  late Box _cacheBox;
  late Box _imageCacheBox;

  Future<void> init() async {
    _cacheBox = await Hive.openBox(_cacheBoxName);
    _imageCacheBox = await Hive.openBox(_imageCacheBoxName);
  }

  // Generic cache methods
  Future<void> set(String key, dynamic value, {Duration? duration}) async {
    final expiryTime = DateTime.now().add(duration ?? _defaultCacheDuration);
    final cacheData = {
      'value': value,
      'expiry': expiryTime.toIso8601String(),};await _cacheBox.put(key, jsonEncode(cacheData));
  }

  T? get<T>(String key) {
    final cachedData = _cacheBox.get(key);
    if (cachedData == null) return null;

    try {
      final decoded = jsonDecode(cachedData);
      final expiryTime = DateTime.parse(decoded['expiry']);

      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired, remove it
        _cacheBox.delete(key);
        return null;
      }

      return decoded['value'] as T;
    } catch (e) {
      // Invalid cache data, remove it
      _cacheBox.delete(key);
      return null;
    }
  }

  Future<void> remove(String key) async {
    await _cacheBox.delete(key);
  }

  Future<void> clear() async {
    await _cacheBox.clear();
    await _imageCacheBox.clear();
  }

  // Image cache methods
  Future<void> cacheImage(String url, List<int> bytes) async {
    final cacheData = {
      'bytes': bytes,
      'timestamp': DateTime.now().toIso8601String(),};await _imageCacheBox.put(url, jsonEncode(cacheData));
  }

  List<int>? getCachedImage(String url) {
    final cachedData = _imageCacheBox.get(url);
    if (cachedData == null) return null;

    try {
      final decoded = jsonDecode(cachedData);
      // Check if image is older than 7 days
      final timestamp = DateTime.parse(decoded['timestamp']);
      if (DateTime.now().difference(timestamp).inDays > 7) {
        _imageCacheBox.delete(url);
        return null;
      }

      final bytes = List<int>.from(decoded['bytes']);
      return bytes;
    } catch (e) {
      _imageCacheBox.delete(url);
      return null;
    }
  }

  // Cache statistics
  int get cacheSize => _cacheBox.length;
  int get imageCacheSize => _imageCacheBox.length;

  // Clean expired cache entries
  Future<void> cleanExpiredCache() async {
    final keysToDelete = <String>[];

    for (final key in _cacheBox.keys) {
      final cachedData = _cacheBox.get(key);
      if (cachedData != null) {
        try {
          final decoded = jsonDecode(cachedData);
          final expiryTime = DateTime.parse(decoded['expiry']);

          if (DateTime.now().isAfter(expiryTime)) {
            keysToDelete.add(key);
          }
        } catch (e) {
          keysToDelete.add(key);
        }
      }
    }

    await _cacheBox.deleteAll(keysToDelete);

    // Clean old images
    final imageKeysToDelete = <String>[];
    for (final key in _imageCacheBox.keys) {
      final cachedData = _imageCacheBox.get(key);
      if (cachedData != null) {
        try {
          final decoded = jsonDecode(cachedData);
          final timestamp = DateTime.parse(decoded['timestamp']);
          if (DateTime.now().difference(timestamp).inDays > 7) {
            imageKeysToDelete.add(key);
          }
        } catch (e) {
          imageKeysToDelete.add(key);
        }
      }
    }

    await _imageCacheBox.deleteAll(imageKeysToDelete);
  }
}




