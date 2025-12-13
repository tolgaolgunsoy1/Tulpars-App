import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

class EventService {
  static const String _eventsKey = 'events_data';
  
  static Future<List<EventModel>> getEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = prefs.getString(_eventsKey);
      
      if (eventsJson != null) {
        final List<dynamic> eventsList = jsonDecode(eventsJson);
        return eventsList.map((json) => EventModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Return sample events if error
    }
    
    return _getSampleEvents();
  }
  
  static Future<bool> addEvent(EventModel event) async {
    try {
      final events = await getEvents();
      events.add(event);
      return await _saveEvents(events);
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> updateEvent(EventModel event) async {
    try {
      final events = await getEvents();
      final index = events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        events[index] = event;
        return await _saveEvents(events);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> deleteEvent(String eventId) async {
    try {
      final events = await getEvents();
      events.removeWhere((e) => e.id == eventId);
      return await _saveEvents(events);
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> _saveEvents(List<EventModel> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = jsonEncode(events.map((e) => e.toJson()).toList());
      return await prefs.setString(_eventsKey, eventsJson);
    } catch (e) {
      return false;
    }
  }
  
  static List<EventModel> _getSampleEvents() {
    return [
      EventModel(
        id: '1',
        title: 'İlk Yardım Eğitimi',
        description: 'Temel ilk yardım teknikleri ve uygulamaları',
        date: DateTime.now().add(const Duration(days: 7)),
        location: 'Tulpars Derneği Merkez',
        category: 'Eğitim',
        maxParticipants: 30,
        currentParticipants: 12,
        createdAt: DateTime.now(),
      ),
      EventModel(
        id: '2',
        title: 'Arama Kurtarma Tatbikatı',
        description: 'Gerçek senaryolarla arama kurtarma uygulamaları',
        date: DateTime.now().add(const Duration(days: 14)),
        location: 'Ankara Dış Alan',
        category: 'Tatbikat',
        maxParticipants: 20,
        currentParticipants: 8,
        createdAt: DateTime.now(),
      ),
    ];
  }
}