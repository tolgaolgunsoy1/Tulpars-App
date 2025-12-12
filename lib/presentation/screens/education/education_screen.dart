import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import 'category_modules_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Yangın',
      'description': 'Yangın güvenliği ve söndürme teknikleri',
      'icon': Icons.local_fire_department,
      'color': const Color(0xFFDC2626),
      'moduleCount': 5,
      'completedCount': 2,
      'estimatedTime': '2 saat',
    },
    {
      'title': 'Deprem',
      'description': 'Deprem güvenliği ve hazırlık',
      'icon': Icons.home_repair_service,
      'color': const Color(0xFFF59E0B),
      'moduleCount': 5,
      'completedCount': 1,
      'estimatedTime': '2.5 saat',
    },
    {
      'title': 'İlk Yardım',
      'description': 'Temel ilk yardım ve CPR',
      'icon': Icons.medical_services,
      'color': const Color(0xFF10B981),
      'moduleCount': 5,
      'completedCount': 0,
      'estimatedTime': '3 saat',
    },
    {
      'title': 'Su Güvenliği',
      'description': 'Su güvenliği ve boğulma önleme',
      'icon': Icons.pool,
      'color': const Color(0xFF3B82F6),
      'moduleCount': 5,
      'completedCount': 0,
      'estimatedTime': '1.5 saat',
    },
  ];



  List<Map<String, dynamic>> _getModulesForCategory(String categoryTitle) {
    switch (categoryTitle) {
      case 'Yangın':
        return [
          {'title': 'Yangın Güvenliği Temelleri', 'duration': '15 dk'},
          {'title': 'Yangın Çıkış Yolları', 'duration': '12 dk'},
          {'title': 'Yangın Söndürme Teknikleri', 'duration': '18 dk'},
          {'title': 'Yangın Önleme Stratejileri', 'duration': '20 dk'},
          {'title': 'Acil Durum Prosedürleri', 'duration': '16 dk'},
        ];
      case 'Deprem':
        return [
          {'title': 'Deprem Güvenliği Temelleri', 'duration': '20 dk'},
          {'title': 'Deprem Öncesi Hazırlık', 'duration': '18 dk'},
          {'title': 'Deprem Anında Yapılacaklar', 'duration': '15 dk'},
          {'title': 'Deprem Sonrası Müdahale', 'duration': '22 dk'},
          {'title': 'Aile Acil Durum Planı', 'duration': '16 dk'},
        ];
      case 'İlk Yardım':
        return [
          {'title': 'Giriş ve Genel İlkeler', 'duration': '25 dk'},
          {'title': 'Temel Yaşam Desteği', 'duration': '30 dk'},
          {'title': 'Kanama Kontrolü', 'duration': '20 dk'},
          {'title': 'Kırık ve Çıkıklar', 'duration': '22 dk'},
          {'title': 'Zehirlenme Vakaları', 'duration': '18 dk'},
        ];
      case 'Su Güvenliği':
        return [
          {'title': 'Su Güvenliği Temelleri', 'duration': '12 dk'},
          {'title': 'Boğulma Önleme', 'duration': '15 dk'},
          {'title': 'Su Kurtarma Teknikleri', 'duration': '20 dk'},
          {'title': 'Havuz ve Deniz Güvenliği', 'duration': '14 dk'},
          {'title': 'Çocuk Su Güvenliği', 'duration': '10 dk'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF003875),
              Color(0xFF0056B3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.go('/main'),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Eğitimler',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Sivil Savunma Eğitim Merkezi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildProgressOverview(),
          const SizedBox(height: 24),
          const Text(
            'Eğitim Kategorileri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryGrid(),
          const SizedBox(height: 24),
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003875), Color(0xFF0056B3)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003875).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Genel İlerleme',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildProgressItem('3', '20', 'Tamamlanan\nModül'),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildProgressItem('17', '20', 'Kalan\nModül'),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildProgressItem('15', '100', 'Başarı\nOranı %'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String value, String total, String label) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '/$total',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _buildCategoryCard(category),
        );
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final progress = category['completedCount'] / category['moduleCount'];
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryModulesScreen(
                title: category['title'],
                color: category['color'],
                icon: category['icon'],
                description: category['description'],
                modules: _getModulesForCategory(category['title']),
                completedModules: {},
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: category['color'].withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: category['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  category['icon'],
                  color: category['color'],
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                category['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category['description'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    category['estimatedTime'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${category['completedCount']}/${category['moduleCount']} Modül',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: category['color'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(category['color']),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights, color: Color(0xFF003875), size: 24),
              SizedBox(width: 12),
              Text(
                'Hızlı İstatistikler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '20',
                  'Toplam Modül',
                  Icons.library_books,
                  const Color(0xFF10B981),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '4',
                  'Kategori',
                  Icons.category,
                  const Color(0xFF3B82F6),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '9h',
                  'Toplam Süre',
                  Icons.schedule,
                  const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }


}
