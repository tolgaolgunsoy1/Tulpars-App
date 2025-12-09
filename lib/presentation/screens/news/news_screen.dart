import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/connectivity_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ConnectivityService _connectivityService = ConnectivityService();

  String _searchQuery = '';
  String _selectedCategory = 'Tümü';
  bool _isSearching = false;
  bool _isConnected = true;

  final List<String> _categories = [
    'Tümü',
    'Genel Haberler',
    'Basında Biz',
    'Sosyal Dayanışma',
    'Eğitimler',
    'Gençlik Spor',
    'Sivil Savunma',
    'Arama-Kurtarma',
    'Doğada Yaşam',
    'Faaliyetler',
  ];

  // Mock data - replace with actual data from Firebase
  final List<Map<String, dynamic>> _newsList = [
    {
      'id': '1',
      'title': 'Tulpars Arama Kurtarma Timi\'nden Başarılı Operasyon',
      'summary':
          'Kahramanmaraş\'ta gerçekleşen arama kurtarma operasyonunda 3 vatandaş güvenli şekilde kurtarıldı.',
      'content': 'Detaylı haber içeriği burada yer alacak...',
      'image':
          'https://via.placeholder.com/400x200/003875/FFFFFF?text=Tulpars+Operasyon',
      'category': 'Arama-Kurtarma',
      'author': 'Tulpars Derneği',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'readTime': '3 dk',
      'isFavorite': false,
      'commentCount': 12,
      'viewCount': 245,
      'tags': ['arama-kurtarma', 'operasyon', 'kahramanmaraş'],
    },
    {
      'id': '2',
      'title': 'Gençlik Spor Kulübü Basketbol Takımı Şampiyon Oldu',
      'summary':
          'Tulpars Gençlik Spor Kulübü basketbol takımı bölgesel şampiyonada birincilik elde etti.',
      'content': 'Detaylı haber içeriği burada yer alacak...',
      'image':
          'https://via.placeholder.com/400x200/F59E0B/000000?text=Basketbol+Sampiyonu',
      'category': 'Gençlik Spor',
      'author': 'Spor Komitesi',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'readTime': '2 dk',
      'isFavorite': true,
      'commentCount': 8,
      'viewCount': 189,
      'tags': ['basketbol', 'şampiyona', 'gençlik'],
    },
    {
      'id': '3',
      'title': 'Sivil Savunma Eğitimi Başarıyla Tamamlandı',
      'summary':
          '150 kişilik gruba deprem ve yangın güvenliği eğitimi verildi.',
      'content': 'Detaylı haber içeriği burada yer alacak...',
      'image':
          'https://via.placeholder.com/400x200/DC2626/FFFFFF?text=Sivil+Savunma',
      'category': 'Sivil Savunma',
      'author': 'Eğitim Koordinatörü',
      'date': DateTime.now().subtract(const Duration(hours: 8)),
      'readTime': '4 dk',
      'isFavorite': false,
      'commentCount': 15,
      'viewCount': 312,
      'tags': ['eğitim', 'sivil-savunma', 'deprem'],
    },
    {
      'id': '4',
      'title': 'Doğada Yaşam Kulübü Trekking Etkinliği',
      'summary':
          'Saklıkent Kanyonu\'nda unutulmaz bir trekking deneyimi yaşandı.',
      'content': 'Detaylı haber içeriği burada yer alacak...',
      'image':
          'https://via.placeholder.com/400x200/10B981/FFFFFF?text=Doğa+Yürüyüşü',
      'category': 'Doğada Yaşam',
      'author': 'Doğa Sporları',
      'date': DateTime.now().subtract(const Duration(hours: 12)),
      'readTime': '3 dk',
      'isFavorite': true,
      'commentCount': 6,
      'viewCount': 156,
      'tags': ['trekking', 'doğa', 'saklıkent'],
    },
    {
      'id': '5',
      'title': 'Sosyal Dayanışma: Gıda Kolisi Dağıtımı',
      'summary':
          'İhtiyaç sahibi 50 aileye gıda kolisi dağıtımı gerçekleştirildi.',
      'content': 'Detaylı haber içeriği burada yer alacak...',
      'image':
          'https://via.placeholder.com/400x200/8B5CF6/FFFFFF?text=Sosyal+Dayanışma',
      'category': 'Sosyal Dayanışma',
      'author': 'Sosyal Hizmetler',
      'date': DateTime.now().subtract(const Duration(hours: 18)),
      'readTime': '2 dk',
      'isFavorite': false,
      'commentCount': 9,
      'viewCount': 278,
      'tags': ['sosyal', 'gıda', 'dayanışma'],
    },
  ];

  List<Map<String, dynamic>> get _filteredNews {
    return _newsList.where((news) {
      final matchesCategory =
          _selectedCategory == 'Tümü' || news['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          news['title'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
          news['summary'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
          news['tags'].any(
            (tag) => tag.toString().toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
    });

    // Initialize connectivity
    _connectivityService.initialize().then((_) {
      setState(() {
        _isConnected = _connectivityService.isConnected;
      });
    });

    // Listen for connectivity changes
    _connectivityService.connectionStream.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleFavorite(String newsId) {
    setState(() {
      final news = _newsList.firstWhere((item) => item['id'] == newsId);
      news['isFavorite'] = !news['isFavorite'];
    });
    // TODO: Update favorite status in backend
  }

  void _shareNews(Map<String, dynamic> news) {
    Share.share(
      '${news['title']}\n\n${news['summary']}\n\nHaberi okumak için: ${AppConstants.websiteUrl}',
      subject: news['title'],
    );
  }

  void _openNewsDetail(Map<String, dynamic> news) {
    // TODO: Navigate to news detail screen
    debugPrint('Open news detail: ${news['id']}');
  }

  void _openComments(Map<String, dynamic> news) {
    // TODO: Open comments modal or navigate to comments screen
    debugPrint('Open comments for news: ${news['id']}');
  }

  Future<void> _refreshNews() async {
    // TODO: Fetch latest news from backend
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003875),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/main'),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Haber ara...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
              )
            : const Text(
                'Haberler',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
        actions: [
          // Connectivity indicator
          if (!_isConnected)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Tooltip(
                message: 'İnternet bağlantısı yok - Önbellekten gösteriliyor',
                child: Icon(
                  Icons.wifi_off,
                  color: Colors.orange.shade600,
                  size: 20,
                ),
              ),
            ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Open advanced filters
              debugPrint('Open filters');
            },
          ),
        ],
        bottom: _isSearching
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs:
                    _categories.map((category) => Tab(text: category)).toList(),
              ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: _filteredNews.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _filteredNews.length,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                itemBuilder: (context, index) {
                  final news = _filteredNews[index];
                  return _buildNewsCard(news);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty
                ? Icons.search_off
                : _isConnected
                    ? Icons.article_outlined
                    : Icons.wifi_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateSubtitle(),
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          if (!_isConnected) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final connected = await _connectivityService.checkConnection();
                if (connected && mounted) {
                  await _refreshNews();
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Yeniden Bağlanmayı Dene'),
            ),
          ],
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    if (_searchQuery.isNotEmpty) {
      return '"$_searchQuery" için sonuç bulunamadı';
    }
    if (!_isConnected) {
      return 'İnternet bağlantısı yok';
    }
    return 'Bu kategoride haber bulunmuyor';
  }

  String _getEmptyStateSubtitle() {
    if (_searchQuery.isNotEmpty) {
      return 'Farklı anahtar kelimeler veya kategoriler deneyin';
    }
    if (!_isConnected) {
      return 'İnternet bağlantınızı kontrol edin ve tekrar deneyin';
    }
    return 'Farklı kategoriler deneyin';
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openNewsDetail(news),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                news['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(news['category']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      news['category'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    news['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Summary
                  Text(
                    news['summary'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Meta Information
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news['author'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${news['readTime']} okuma',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Date and Stats
                  Row(
                    children: [
                      Text(
                        _formatDate(news['date']),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${news['viewCount']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action Buttons
                  Row(
                    children: [
                      // Comments
                      TextButton.icon(
                        onPressed: () => _openComments(news),
                        icon: Icon(
                          Icons.comment_outlined,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        label: Text(
                          '${news['commentCount']}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      const Spacer(),

                      // Favorite
                      IconButton(
                        onPressed: () => _toggleFavorite(news['id']),
                        icon: Icon(
                          news['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: news['isFavorite']
                              ? Colors.red
                              : Colors.grey.shade600,
                        ),
                        tooltip: news['isFavorite']
                            ? 'Favorilerden çıkar'
                            : 'Favorilere ekle',
                      ),
                      // Share
                      IconButton(
                        onPressed: () => _shareNews(news),
                        icon: Icon(
                          Icons.share_outlined,
                          color: Colors.grey.shade600,
                        ),
                        tooltip: 'Paylaş',
                      ),
                      // Notifications
                      IconButton(
                        onPressed: () {
                          // TODO: Toggle notifications for this news
                          debugPrint(
                            'Toggle notifications for news: ${news['id']}',
                          );
                        },
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.grey.shade600,
                        ),
                        tooltip: 'Bildirim ayarları',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Arama-Kurtarma':
        return const Color(0xFFDC2626);
      case 'Gençlik Spor':
        return const Color(0xFFF59E0B);
      case 'Sivil Savunma':
        return const Color(0xFF003875);
      case 'Doğada Yaşam':
        return const Color(0xFF10B981);
      case 'Sosyal Dayanışma':
        return const Color(0xFF8B5CF6);
      case 'Eğitimler':
        return const Color(0xFF06B6D4);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }
}
