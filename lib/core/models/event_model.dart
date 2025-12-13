class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String category;
  final int maxParticipants;
  final int currentParticipants;
  final bool isActive;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    required this.maxParticipants,
    this.currentParticipants = 0,
    this.isActive = true,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'category': category,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get timeUntilEvent {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.isNegative) return 'Geçmiş';
    if (difference.inDays > 0) return '${difference.inDays} gün sonra';
    if (difference.inHours > 0) return '${difference.inHours} saat sonra';
    return '${difference.inMinutes} dakika sonra';
  }

  bool get isFull => currentParticipants >= maxParticipants;
  bool get isUpcoming => date.isAfter(DateTime.now());
}