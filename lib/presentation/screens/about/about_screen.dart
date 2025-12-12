import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('URL launch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003875),
        elevation: 0,
        title: const Text(
          'Hakkımızda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMissionSection(),
              const SizedBox(height: 24),
              _buildServicesSection(),
              const SizedBox(height: 24),
              _buildActivitiesSection(),
              const SizedBox(height: 24),
              _buildContactSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003875), Color(0xFF0055A5)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003875).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 48,
            color: Colors.white,
          ),
          SizedBox(height: 12),
          Text(
            'TULPARS DERNEĞİ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sivil Savunma ve Arama Kurtarma Derneği',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Misyonumuz',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tulpars Derneği, sivil savunma, arama-kurtarma, gençlik sporları ve sosyal dayanışma alanlarında faaliyet gösteren bir sivil toplum kuruluşudur. Toplumun güvenliği ve refahı için çalışan gönüllülerimizle birlikte, acil durumlarda hızlı ve etkili müdahale sağlamayı hedefliyoruz.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {
        'icon': Icons.search,
        'title': 'Arama Kurtarma',
        'description': 'Profesyonel arama kurtarma operasyonları ve acil müdahale hizmetleri',
        'color': const Color(0xFFDC2626),
      },
      {
        'icon': Icons.security,
        'title': 'Sivil Savunma',
        'description': 'Toplum güvenliği ve sivil savunma eğitimleri',
        'color': const Color(0xFF003875),
      },
      {
        'icon': Icons.sports_basketball,
        'title': 'Gençlik Sporları',
        'description': 'Gençlerin fiziksel ve sosyal gelişimini destekleyen spor faaliyetleri',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.people_alt,
        'title': 'Sosyal Dayanışma',
        'description': 'Toplumsal yardımlaşma ve sosyal sorumluluk projeleri',
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hizmet Alanlarımız',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        ...services.map((service) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (service['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          service['icon'] as IconData,
                          color: service['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service['description'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),),
      ],
    );
  }

  Widget _buildActivitiesSection() {
    final activities = [
      'Acil durum müdahale eğitimleri',
      'İlk yardım sertifika programları',
      'Arama kurtarma operasyonları',
      'Gençlik spor kulübü faaliyetleri',
      'Sosyal sorumluluk projeleri',
      'Toplum bilgilendirme seminerleri',
      'Gönüllü eğitim programları',
      'Afet hazırlık çalışmaları',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Faaliyetlerimiz',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: activities.map((activity) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF003875),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            activity,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF374151),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'İletişim',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildContactItem(
                  icon: Icons.language,
                  title: 'Website',
                  value: 'www.tulpars.org.tr',
                  onTap: () => _launchURL('https://www.tulpars.org.tr'),
                ),
                const Divider(height: 16),
                _buildContactItem(
                  icon: Icons.email,
                  title: 'E-posta',
                  value: 'info@tulpars.org.tr',
                  onTap: () => _launchURL('mailto:info@tulpars.org.tr'),
                ),
                const Divider(height: 16),
                _buildContactItem(
                  icon: Icons.location_on,
                  title: 'Adres',
                  value: 'Kayseri, Türkiye',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF003875).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF003875).withValues(alpha: 0.3),
            ),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.volunteer_activism,
                color: Color(0xFF003875),
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gönüllü olmak ve faaliyetlerimize katılmak için bizimle iletişime geçin.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF003875),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF003875), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap.toString() != '() {}')
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF6B7280),
              ),
          ],
        ),
      ),
    );
  }
}