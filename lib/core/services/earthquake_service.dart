import 'dart:convert';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EarthquakeService {
  static final _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));
  static const String _cacheKey = 'earthquake_cache';
  static const String _lastUpdateKey = 'earthquake_last_update';
  
  static Future<List<EarthquakeData>> getRecentEarthquakes({int limit = 10}) async {
    final earthquakes = <EarthquakeData>[];
    
    // Try multiple sources
    final sources = [
      _getFromAFAD,
      _getFromKandilli,
      _getFromUSGS,
    ];
    
    for (final source in sources) {
      try {
        final data = await source(limit);
        if (data.isNotEmpty) {
          earthquakes.addAll(data);
          break;
        }
      } catch (e) {
        continue;
      }
    }
    
    // Cache successful results
    if (earthquakes.isNotEmpty) {
      await _cacheEarthquakes(earthquakes);
    } else {
      // Return cached data if available
      return await _getCachedEarthquakes();
    }
    
    // Sort by time and magnitude
    earthquakes.sort((a, b) => b.time.compareTo(a.time));
    return earthquakes.take(limit).toList();
  }
  
  static Future<List<EarthquakeData>> _getFromAFAD(int limit) async {
    final response = await _dio.get(
      'https://deprem.afad.gov.tr/apiv2/event/filter',
      queryParameters: {
        'start': DateTime.now().subtract(const Duration(hours: 24)).toIso8601String(),
        'end': DateTime.now().toIso8601String(),
        'minmag': '1.5',
        'limit': limit.toString(),
      },
    );
    
    if (response.statusCode == 200 && response.data['metadata']['count'] > 0) {
      return (response.data['result'] as List)
          .map((e) => EarthquakeData.fromAFAD(e))
          .toList();
    }
    return [];
  }
  
  static Future<List<EarthquakeData>> _getFromKandilli(int limit) async {
    final response = await _dio.get('http://www.koeri.boun.edu.tr/scripts/lst0.asp');
    if (response.statusCode == 200) {
      return _parseKandilliData(response.data, limit);
    }
    return [];
  }
  
  static Future<List<EarthquakeData>> _getFromUSGS(int limit) async {
    final response = await _dio.get(
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson',
    );
    
    if (response.statusCode == 200) {
      final features = response.data['features'] as List;
      return features
          .where((f) => _isInTurkeyRegion(f['geometry']['coordinates']))
          .take(limit)
          .map((f) => EarthquakeData.fromUSGS(f))
          .toList();
    }
    return [];
  }
  
  static bool _isInTurkeyRegion(List coordinates) {
    final lon = coordinates[0] as double;
    final lat = coordinates[1] as double;
    return lon >= 26.0 && lon <= 45.0 && lat >= 35.0 && lat <= 42.0;
  }
  
  static List<EarthquakeData> _parseKandilliData(String html, int limit) {
    final earthquakes = <EarthquakeData>[];
    final lines = html.split('\n');
    
    for (final line in lines) {
      if (earthquakes.length >= limit) break;
      if (line.contains('M') && line.length > 100) {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length >= 8) {
          earthquakes.add(EarthquakeData(
            magnitude: double.tryParse(parts[6]) ?? 0.0,
            location: parts.sublist(7).join(' '),
            time: _parseKandilliTime(parts[0], parts[1]),
            depth: double.tryParse(parts[4]) ?? 0.0,
            latitude: double.tryParse(parts[2]) ?? 0.0,
            longitude: double.tryParse(parts[3]) ?? 0.0,
            source: 'Kandilli',
          ));
        }
      }
    }
    return earthquakes;
  }
  
  static DateTime _parseKandilliTime(String date, String time) {
    try {
      final dateParts = date.split('.');
      final timeParts = time.split(':');
      return DateTime(
        2000 + int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (_) {
      return DateTime.now().subtract(const Duration(minutes: 30));
    }
  }
  
  static Future<void> _cacheEarthquakes(List<EarthquakeData> earthquakes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = earthquakes.map((e) => e.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  static Future<List<EarthquakeData>> _getCachedEarthquakes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        final jsonList = jsonDecode(cached) as List;
        return jsonList.map((e) => EarthquakeData.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }
}

class EarthquakeData {
  final double magnitude;
  final String location;
  final DateTime time;
  final double depth;
  final double latitude;
  final double longitude;
  final String source;
  final String? id;
  
  EarthquakeData({
    required this.magnitude,
    required this.location,
    required this.time,
    required this.depth,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.source = 'AFAD',
    this.id,
  });
  
  factory EarthquakeData.fromJson(Map<String, dynamic> json) {
    return EarthquakeData(
      magnitude: double.tryParse(json['magnitude']?.toString() ?? '0') ?? 0.0,
      location: json['location'] ?? 'Bilinmeyen',
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
      depth: double.tryParse(json['depth']?.toString() ?? '0') ?? 0.0,
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      source: json['source'] ?? 'AFAD',
      id: json['id'],
    );
  }
  
  factory EarthquakeData.fromAFAD(Map<String, dynamic> json) {
    return EarthquakeData(
      magnitude: double.tryParse(json['mag']?.toString() ?? '0') ?? 0.0,
      location: json['location'] ?? 'Bilinmeyen',
      time: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      depth: double.tryParse(json['depth']?.toString() ?? '0') ?? 0.0,
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      source: 'AFAD',
      id: json['eventID'],
    );
  }
  
  factory EarthquakeData.fromUSGS(Map<String, dynamic> json) {
    final props = json['properties'];
    final coords = json['geometry']['coordinates'];
    return EarthquakeData(
      magnitude: double.tryParse(props['mag']?.toString() ?? '0') ?? 0.0,
      location: props['place'] ?? 'Bilinmeyen',
      time: DateTime.fromMillisecondsSinceEpoch(props['time'] ?? 0),
      depth: double.tryParse(coords[2]?.toString() ?? '0') ?? 0.0,
      latitude: double.tryParse(coords[1]?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(coords[0]?.toString() ?? '0') ?? 0.0,
      source: 'USGS',
      id: json['id'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'magnitude': magnitude,
      'location': location,
      'time': time.toIso8601String(),
      'depth': depth,
      'latitude': latitude,
      'longitude': longitude,
      'source': source,
      'id': id,
    };
  }
  
  String get timeAgo {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Şimdi';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} sa önce';
    return '${diff.inDays} gün önce';
  }
  
  String get severityLevel {
    if (magnitude >= 6.0) return 'Çok Yüksek';
    if (magnitude >= 5.0) return 'Yüksek';
    if (magnitude >= 4.0) return 'Orta';
    if (magnitude >= 3.0) return 'Düşük';
    return 'Çok Düşük';
  }
  
  Color get severityColor {
    if (magnitude >= 6.0) return const Color(0xFF7F1D1D);
    if (magnitude >= 5.0) return const Color(0xFFDC2626);
    if (magnitude >= 4.0) return const Color(0xFFF59E0B);
    if (magnitude >= 3.0) return const Color(0xFF059669);
    return const Color(0xFF6B7280);
  }
  
  IconData get severityIcon {
    if (magnitude >= 5.0) return Icons.warning;
    if (magnitude >= 4.0) return Icons.info;
    return Icons.circle;
  }
  
  String get riskLevel {
    if (magnitude >= 6.0) return 'Acil Müdahale Gerekli';
    if (magnitude >= 5.0) return 'Yüksek Risk';
    if (magnitude >= 4.0) return 'Orta Risk';
    return 'Düşük Risk';
  }
  
  double get distanceFromAnkara {
    // Ankara coordinates: 39.9334, 32.8597
    const ankaraLat = 39.9334;
    const ankaraLon = 32.8597;
    return _calculateDistance(latitude, longitude, ankaraLat, ankaraLon);
  }
  
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }
  
  double _toRadians(double degrees) => degrees * (math.pi / 180);
}