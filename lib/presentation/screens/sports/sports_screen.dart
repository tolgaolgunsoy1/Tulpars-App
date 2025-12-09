import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class SportsScreen extends StatefulWidget {
  const SportsScreen({super.key});

  @override
  State<SportsScreen> createState() => _SportsScreenState();
}

class _SportsScreenState extends State<SportsScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _sportsActivities = [
    {
      'id': 'basketball',
      'title': 'Basketbol',
      'description': 'Gençlik basketbol takımı antrenmanları ve maçları',
      'icon': Icons.sports_basketball,
      'color': const Color(0xFFF59E0B),
      'schedule': 'Salı-Perşembe 19:00-21:00',
      'location': 'Tulpars Spor Salonu',
      'participants': 24,
      'coach': 'Ahmet Koç',
      'upcoming': '15 Aralık - Şampiyonluk Maçı',
    },
    {
      'id': 'football',
      'title': 'Futbol',
      'description': 'Amatör futbol ligi ve gençlik futbol okulu',
      'icon': Icons.sports_soccer,
      'color': const Color(0xFF10B981),
      'schedule': 'Cumartesi-Pazar 10:00-12:00',
      'location': 'Tulpars Sahası',
      'participants': 32,
      'coach': 'Mehmet Hoca',
      'upcoming': '20 Aralık - Derbi Maçı',
    },
    {
      'id': 'volleyball',
      'title': 'Voleybol',
      'description': 'Kadın voleybol takımı ve genç voleybol',
      'icon': Icons.sports_volleyball,
      'color': const Color(0xFF8B5CF6),
      'schedule': 'Çarşamba-Cuma 18:00-20:00',
      'location': 'Tulpars Spor Salonu',
      'participants': 18,
      'coach': 'Ayşe Antrenör',
      'upcoming': '25 Aralık - Turnuva Finali',
    },
    {
      'id': 'trekking',
      'title': 'Doğa Yürüyüşü',
      'description': 'Haftalık doğa yürüyüşü ve kamp aktiviteleri',
      'icon': Icons.terrain,
      'color': const Color(0xFF06B6D4),
      'schedule': 'Pazar 09:00-16:00',
      'location': 'Saklıkent Kanyonu',
      'participants': 45,
      'coach': 'Doğa Lideri Hasan',
      'upcoming': '30 Aralık - Kış Kampı',
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Basketbol Şampiyonası',
      'description': '2024 Gençlik Basketbol Ligi Şampiyonu',
      'date': '15 Kasım 2024',
      'icon': Icons.emoji_events,
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Futbol Kupası',
      'description': 'Amatör Futbol Ligi İkinciliği',
      'date': '22 Ekim 2024',
      'icon': Icons.sports_soccer,
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Katılım Ödülü',
      'description': 'İstanbul Gençlik Spor Ödülleri',
      'date': '5 Eylül 2024',
      'icon': Icons.military_tech,
      'color': const Color(0xFF8B5CF6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor),
        elevation: 0,
        title: const Text(
          'Gençlik Spor',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 32),

              // Sports Activities
              _buildSportsActivities(),

              const SizedBox(height: 32),

              // Achievements
              _buildAchievements(),

              const SizedBox(height: 32),

              // Join Section
              _buildJoinSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(AppConstants.primaryColor),
            Color(AppConstants.primaryLightColor),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.primaryColor).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tulpars Gençlik Spor Kulübü',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sporla büyüyen, dayanışmayla güçlenen gençler için faaliyetlerimizi keşfedin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportsActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spor Aktivitelerimiz',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        ..._sportsActivities.map(_buildActivityCard),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: activity['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  activity['icon'],
                  color: activity['color'],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      activity['description'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Details
          Row(
            children: [
              _buildDetailItem(Icons.schedule, activity['schedule']),
              const SizedBox(width: 16),
              _buildDetailItem(Icons.location_on, activity['location']),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildDetailItem(
                Icons.people,
                '${activity['participants']} Katılımcı',
              ),
              const SizedBox(width: 16),
              _buildDetailItem(Icons.person, activity['coach']),
            ],
          ),
          const SizedBox(height: 16),
          // Upcoming Event
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(AppConstants.accentColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(AppConstants.accentColor).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.event,
                  color: Color(AppConstants.accentColor),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activity['upcoming'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Join Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Join activity
                _showJoinDialog(activity);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: activity['color']),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Katıl',
                style: TextStyle(
                  color: activity['color'],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF64748B),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Başarılarımız',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: _achievements.map((achievement) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: achievement['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: achievement['color'].withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      achievement['icon'],
                      color: achievement['color'],
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: achievement['color'],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement['date'],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(AppConstants.successColor), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.successColor).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.group_add,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Spora Katılın!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tulpars Gençlik Spor Kulübü\'ne katılın ve sporun gücünü keşfedin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to membership or contact
                _showSnackBar('Üyelik başvurusu için iletişim bölümüne bakın');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(AppConstants.successColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Üye Ol',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '${activity['title']} Aktivitesine Katıl',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(AppConstants.primaryColor),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              activity['icon'],
              color: activity['color'],
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Bu aktiviteye katılmak istediğinizden emin misiniz?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Antrenman: ${activity['schedule']}\nKonum: ${activity['location']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              _showSnackBar(
                '${activity['title']} aktivitesine katılım başvurunuz alındı',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: activity['color'],
            ),
            child: const Text('Katıl'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(AppConstants.successColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
