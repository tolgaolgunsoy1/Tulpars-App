import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class NewsService {
  static const String _newsKey = 'news_data';
  
  static Future<List<NewsModel>> getNews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newsJson = prefs.getString(_newsKey);
      
      if (newsJson != null) {
        final List<dynamic> newsList = jsonDecode(newsJson);
        return newsList.map((json) => NewsModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Return sample news if error
    }
    
    return _getSampleNews();
  }
  
  static Future<bool> addNews(NewsModel news) async {
    try {
      final newsList = await getNews();
      newsList.insert(0, news); // Add to beginning
      return await _saveNews(newsList);
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> updateNews(NewsModel news) async {
    try {
      final newsList = await getNews();
      final index = newsList.indexWhere((n) => n.id == news.id);
      if (index != -1) {
        newsList[index] = news;
        return await _saveNews(newsList);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> deleteNews(String newsId) async {
    try {
      final newsList = await getNews();
      newsList.removeWhere((n) => n.id == newsId);
      return await _saveNews(newsList);
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> _saveNews(List<NewsModel> newsList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newsJson = jsonEncode(newsList.map((n) => n.toJson()).toList());
      return await prefs.setString(_newsKey, newsJson);
    } catch (e) {
      return false;
    }
  }
  
  static List<NewsModel> _getSampleNews() {
    return [
      NewsModel(
        id: '1',
        title: 'Yeni Arama Kurtarma Ekipmanları Alındı',
        content: 'Tulpars Derneği olarak arama kurtarma operasyonlarımızda kullanmak üzere son teknoloji ekipmanlar aldık. Bu ekipmanlar sayesinde daha etkili müdahaleler gerçekleştirebileceğiz.',
        category: 'Arama-Kurtarma',
        author: 'Tulpars Derneği',
        publishDate: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now(),
      ),
      NewsModel(
        id: '2',
        title: 'İlk Yardım Eğitimi Başarıyla Tamamlandı',
        content: 'Geçtiğimiz hafta düzenlediğimiz ilk yardım eğitimi 30 katılımcı ile başarıyla tamamlandı. Katılımcılar temel ilk yardım tekniklerini öğrendi.',
        category: 'Eğitim',
        author: 'Eğitim Koordinatörü',
        publishDate: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now(),
      ),
      NewsModel(
        id: '3',
        title: 'Sivil Savunma Tatbikatı Düzenlendi',
        content: 'Ankara\'da düzenlenen sivil savunma tatbikatına derneğimizden 15 gönüllü katıldı. Tatbikat başarıyla tamamlandı.',
        category: 'Tatbikat',
        author: 'Operasyon Sorumlusu',
        publishDate: DateTime.now().subtract(const Duration(days: 7)),
        createdAt: DateTime.now(),
      ),
    ];
  }
}