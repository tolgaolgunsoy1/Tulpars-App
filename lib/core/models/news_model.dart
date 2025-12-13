class NewsModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String imageUrl;
  final DateTime publishDate;
  final String author;
  final bool isPublished;
  final int viewCount;
  final DateTime createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl = '',
    required this.publishDate,
    required this.author,
    this.isPublished = true,
    this.viewCount = 0,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishDate: DateTime.tryParse(json['publishDate'] ?? '') ?? DateTime.now(),
      author: json['author'] ?? '',
      isPublished: json['isPublished'] ?? true,
      viewCount: json['viewCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'imageUrl': imageUrl,
      'publishDate': publishDate.toIso8601String(),
      'author': author,
      'isPublished': isPublished,
      'viewCount': viewCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get timeAgo {
    final diff = DateTime.now().difference(publishDate);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} sa önce';
    return '${diff.inDays} gün önce';
  }

  String get shortContent {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }
}