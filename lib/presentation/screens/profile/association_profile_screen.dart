import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/navigation_service.dart';

class AssociationProfileScreen extends StatelessWidget {
  const AssociationProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => NavigationService.goBack(context, fallbackRoute: '/profile'),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('TULPARS DERNEĞİ'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF003875),
                      const Color(0xFF003875).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.emergency, size: 80, color: Colors.white),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildQuickActions(context),
                _buildMissionVision(context),
                _buildActivities(context),
                _buildTeam(context),
                _buildAchievements(context),
                _buildContact(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => context.go('/donations'),
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Bağış Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.go('/membership'),
              icon: const Icon(Icons.person_add),
              label: const Text('Üye Ol'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVision(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Misyon & Vizyon',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003875).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.flag, color: Color(0xFF003875)),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Misyonumuz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Afet ve acil durumlarda hızlı müdahale, arama kurtarma operasyonları, ilk yardım hizmetleri ve toplumsal dayanışma ile insanlığa hizmet etmek.',
                    style: TextStyle(height: 1.5),
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003875).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.visibility, color: Color(0xFF003875)),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Vizyonumuz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Türkiye\'nin en güvenilir sivil savunma ve arama kurtarma derneği olarak, profesyonel ekip ve modern ekipmanlarla 7/24 hazır olmak.',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivities(BuildContext context) {
    final activities = [
      {
        'icon': Icons.search,
        'title': 'Arama Kurtarma',
        'desc': 'Deprem, sel ve diğer afetlerde profesyonel arama kurtarma',
        'color': const Color(0xFFF59E0B),
      },
      {
        'icon': Icons.medical_services,
        'title': 'İlk Yardım',
        'desc': 'Acil durumlarda ilk yardım ve sağlık hizmetleri',
        'color': const Color(0xFFDC2626),
      },
      {
        'icon': Icons.school,
        'title': 'Eğitim',
        'desc': 'AFAD ve Kızılhaç onaylı sertifikalı eğitim programları',
        'color': const Color(0xFF10B981),
      },
      {
        'icon': Icons.sports_soccer,
        'title': 'Gençlik Spor',
        'desc': 'Gençlik spor kulübü ve sosyal aktiviteler',
        'color': const Color(0xFF3B82F6),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faaliyetlerimiz',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (activity['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      color: activity['color'] as Color,
                    ),
                  ),
                  title: Text(
                    activity['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(activity['desc'] as String),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTeam(BuildContext context) {
    final team = [
      {'name': 'Ahmet Yılmaz', 'role': 'Başkan', 'image': Icons.person},
      {'name': 'Mehmet Demir', 'role': 'Başkan Yardımcısı', 'image': Icons.person},
      {'name': 'Ayşe Kaya', 'role': 'Genel Sekreter', 'image': Icons.person},
      {'name': 'Fatma Şahin', 'role': 'Eğitim Koordinatörü', 'image': Icons.person},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yönetim Ekibimiz',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: team.length,
              itemBuilder: (context, index) {
                final member = team[index];
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xFF003875).withValues(alpha: 0.1),
                            child: Icon(
                              member['image'] as IconData,
                              color: const Color(0xFF003875),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            member['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            member['role'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    final achievements = [
      {'title': '500+', 'desc': 'Başarılı Operasyon'},
      {'title': '1000+', 'desc': 'Eğitim Alan Kişi'},
      {'title': '50+', 'desc': 'Aktif Gönüllü'},
      {'title': '15+', 'desc': 'Yıllık Deneyim'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Başarılarımız',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: achievements.map((achievement) => Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        achievement['title'] as String,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003875),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement['desc'] as String,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İletişim',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.location_on,
                    'Adres',
                    'Merkez Mahallesi, Atatürk Caddesi No:123\nAnkara, Türkiye',
                    null,
                  ),
                  const Divider(),
                  _buildContactItem(
                    Icons.phone,
                    'Telefon',
                    '+90 312 123 45 67',
                    () => _launchUrl('tel:+903121234567'),
                  ),
                  const Divider(),
                  _buildContactItem(
                    Icons.email,
                    'E-posta',
                    'info@tulpars.org.tr',
                    () => _launchUrl('mailto:info@tulpars.org.tr'),
                  ),
                  const Divider(),
                  _buildContactItem(
                    Icons.language,
                    'Web Sitesi',
                    'www.tulpars.org.tr',
                    () => _launchUrl('https://www.tulpars.org.tr'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String value,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF003875)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: onTap != null ? const Color(0xFF003875) : null,
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}