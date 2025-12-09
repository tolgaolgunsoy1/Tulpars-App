import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with TickerProviderStateMixin {
  final List<String> _categories = [
    'Tümü',
    'Arama-Kurtarma',
    'Eğitimler',
    'Spor Faaliyetleri',
    'Sosyal Etkinlikler',
    'Doğa Yürüyüşü',
  ];

  String _selectedCategory = 'Tümü';

  final List<Map<String, dynamic>> _galleryItems = [
    {
      'id': '1',
      'title': 'Hatay Arama Kurtarma Operasyonu',
      'description': 'Deprem bölgesinde yürütülen arama kurtarma çalışmaları',
      'image':
          'https://via.placeholder.com/400x300/003875/FFFFFF?text=Arama+Kurtarma',
      'category': 'Arama-Kurtarma',
      'date': '15 Kasım 2024',
      'location': 'Hatay',
      'tags': ['operasyon', 'deprem', 'kurtarma'],
    },
    {
      'id': '2',
      'title': 'İlk Yardım Eğitimi',
      'description': 'Gençlere verilen temel ilk yardım eğitimi',
      'image':
          'https://via.placeholder.com/400x300/DC2626/FFFFFF?text=İlk+Yardım',
      'category': 'Eğitimler',
      'date': '22 Ekim 2024',
      'location': 'Tulpars Eğitim Merkezi',
      'tags': ['eğitim', 'ilk-yardım', 'gençlik'],
    },
    {
      'id': '3',
      'title': 'Basketbol Şampiyonası',
      'description': 'Gençlik basketbol takımımızın şampiyonluk sevinci',
      'image':
          'https://via.placeholder.com/400x300/F59E0B/000000?text=Basketbol',
      'category': 'Spor Faaliyetleri',
      'date': '5 Ekim 2024',
      'location': 'Spor Salonu',
      'tags': ['basketbol', 'şampiyona', 'gençlik'],
    },
    {
      'id': '4',
      'title': 'Gıda Dağıtımı',
      'description': 'İhtiyaç sahibi ailelere gıda paketi dağıtımı',
      'image':
          'https://via.placeholder.com/400x300/10B981/FFFFFF?text=Sosyal+Yardım',
      'category': 'Sosyal Etkinlikler',
      'date': '12 Eylül 2024',
      'location': 'Şehitlik Mahallesi',
      'tags': ['sosyal', 'gıda', 'dayanışma'],
    },
    {
      'id': '5',
      'title': 'Saklıkent Kanyonu Trekking',
      'description': 'Doğa yürüyüşü etkinliğimizde unutulmaz anlar',
      'image':
          'https://via.placeholder.com/400x300/06B6D4/FFFFFF?text=Doğa+Yürüyüşü',
      'category': 'Doğa Yürüyüşü',
      'date': '28 Ağustos 2024',
      'location': 'Saklıkent Kanyonu',
      'tags': ['doğa', 'trekking', 'kamp'],
    },
    {
      'id': '6',
      'title': 'Yangın Tatbikatı',
      'description': 'Profesyonel yangın söndürme tatbikatı',
      'image':
          'https://via.placeholder.com/400x300/EF4444/FFFFFF?text=Yangın+Tatbikatı',
      'category': 'Eğitimler',
      'date': '15 Ağustos 2024',
      'location': 'Tatbikat Alanı',
      'tags': ['yangın', 'tatbikat', 'güvenlik'],
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedCategory == 'Tümü') return _galleryItems;
    return _galleryItems
        .where((item) => item['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor),
        elevation: 0,
        title: const Text(
          'Galeri',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter
            _buildCategoryFilter(),

            // Gallery Grid
            Expanded(
              child: _filteredItems.isEmpty
                  ? _buildEmptyState()
                  : _buildGalleryGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor:
                  const Color(AppConstants.primaryColor).withValues(alpha: 0.1),
              checkmarkColor: const Color(AppConstants.primaryColor),
              labelStyle: TextStyle(
                color: isSelected
                    ? const Color(AppConstants.primaryColor)
                    : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(AppConstants.primaryColor)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredItems.length,
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildGalleryItem(item);
      },
    );
  }

  Widget _buildGalleryItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _showImageDetail(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              CachedNetworkImage(
                imageUrl: item['image'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
              // Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['location'],
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Category Badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(item['category']).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['category'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Bu kategoride fotoğraf bulunmuyor',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Farklı bir kategori seçmeyi deneyin',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: item['image'],
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 250,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 250,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Title and Category
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(item['category'])
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['category'],
                              style: TextStyle(
                                color: _getCategoryColor(item['category']),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item['date'],
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        item['description'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item['location'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item['tags'].map<Widget>((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '#$tag',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Share image
                                _showSnackBar(
                                  'Paylaşım özelliği yakında eklenecek',
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Paylaş'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(AppConstants.primaryColor),
                                ),
                                foregroundColor:
                                    const Color(AppConstants.primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Download image
                                _showSnackBar(
                                  'İndirme özelliği yakında eklenecek',
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('İndir'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(AppConstants.primaryColor),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Arama-Kurtarma':
        return const Color(0xFFDC2626);
      case 'Eğitimler':
        return const Color(0xFFF59E0B);
      case 'Spor Faaliyetleri':
        return const Color(0xFF10B981);
      case 'Sosyal Etkinlikler':
        return const Color(0xFF8B5CF6);
      case 'Doğa Yürüyüşü':
        return const Color(0xFF06B6D4);
      default:
        return const Color(AppConstants.primaryColor);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(AppConstants.primaryColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
