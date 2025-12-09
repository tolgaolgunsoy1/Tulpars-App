import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onPressed: () => context.go('/main'),
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
                return Card(
                  margin: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF003875),
                          child: Icon(
                            member['image'] as IconData,
                            color: Colors.white,
                            size: 30,
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
                          maxLines: 2,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
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
            children: [
              Expanded(
                child: _buildStatCard('500+', 'Kurtarılan Can', Icons.favorite),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('1200+', 'Eğitim Alan', Icons.school),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('350+', 'Operasyon', Icons.search),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('15 Yıl', 'Tecrübe', Icons.verified),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF003875)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003875),
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone, color: Color(0xFF003875)),
                  title: const Text('Telefon'),
                  subtitle: const Text('+90 555 123 4567'),
                  onTap: () => _launchUrl('tel:+905551234567'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email, color: Color(0xFF003875)),
                  title: const Text('E-posta'),
                  subtitle: const Text('info@tulpars.org.tr'),
                  onTap: () => _launchUrl('mailto:info@tulpars.org.tr'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Color(0xFF003875)),
                  title: const Text('Adres'),
                  subtitle: const Text('İstanbul, Türkiye'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: Color(0xFF003875)),
                  title: const Text('Web Sitesi'),
                  subtitle: const Text('www.tulpars.org.tr'),
                  onTap: () => _launchUrl('https://www.tulpars.org.tr'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sosyal Medya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(Icons.facebook, () {}),
                      _buildSocialButton(Icons.camera_alt, () {}),
                      _buildSocialButton(Icons.alternate_email, () {}),
                      _buildSocialButton(Icons.video_library, () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF003875).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF003875)),
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
