import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showSnackBar('Telefon uygulaması açılamadı');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC2626),
        elevation: 0,
        title: const Text(
          'Acil Durum',
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
              // Emergency Alert Banner
              _buildEmergencyBanner(),

              const SizedBox(height: 24),

              // Quick Emergency Actions
              _buildQuickActions(),

              const SizedBox(height: 32),

              // Emergency Contacts
              _buildEmergencyContacts(),

              const SizedBox(height: 32),

              // Emergency Procedures
              _buildEmergencyProcedures(),

              const SizedBox(height: 32),

              // Safety Tips
              _buildSafetyTips(),

              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Acil Durumda\nHemen Yardım İsteyin',
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
            'Yaşamınızı tehdit eden durumlarda\n112\'yi arayın',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Erişim',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildEmergencyButton(
                icon: Icons.local_police,
                label: 'Polis\n155',
                color: const Color(0xFF1E40AF),
                phoneNumber: AppConstants.policeNumber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEmergencyButton(
                icon: Icons.local_fire_department,
                label: 'İtfaiye\n110',
                color: const Color(0xFFDC2626),
                phoneNumber: AppConstants.fireNumber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEmergencyButton(
                icon: Icons.local_hospital,
                label: 'Acil\n112',
                color: const Color(0xFF059669),
                phoneNumber: AppConstants.emergencyNumber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEmergencyButton(
                icon: Icons.emergency,
                label: 'Tulpars\nAcil',
                color: const Color(0xFF003875),
                phoneNumber: AppConstants.tulparsEmergency,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoButton(
                icon: Icons.info_outline,
                label: 'Acil\nRehberi',
                color: const Color(0xFFF59E0B),
                onTap: _showEmergencyGuide,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoButton(
                icon: Icons.location_on,
                label: 'En Yakın\nMerkez',
                color: const Color(0xFF10B981),
                onTap: _showNearestCenter,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyButton({
    required IconData icon,
    required String label,
    required Color color,
    required String phoneNumber,
  }) {
    return InkWell(
      onTap: () => _makePhoneCall(phoneNumber),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Önemli Telefon Numaraları',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          title: 'Tulpars Arama Kurtarma',
          phone: AppConstants.tulparsEmergency,
          description: '7/24 acil arama kurtarma desteği',
          icon: Icons.emergency,
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          title: 'AFAD (afet yönetimi)',
          phone: '122',
          description: 'Doğal afet ve acil durum koordinasyonu',
          icon: Icons.warning,
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          title: 'Orman Yangını',
          phone: '177',
          description: 'Orman ve doğal alan yangınları',
          icon: Icons.local_fire_department,
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required String title,
    required String phone,
    required String description,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF003875).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF003875), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003875),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone, color: Color(0xFF003875)),
              onPressed: () => _makePhoneCall(phone),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyProcedures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acil Durum Prosedürleri',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        _buildProcedureCard(
          title: 'Deprem Anında',
          steps: [
            'Sakin olun ve panik yapmayın',
            'Masaların altına veya köşe başlarına sığının',
            'Başınızı ve boynunuzu koruyun',
            'Sarsıntı durduktan sonra tahliye edin',
          ],
        ),
        const SizedBox(height: 12),
        _buildProcedureCard(
          title: 'Yangın Anında',
          steps: [
            'Hemen yangın alarmını çalın',
            'Elektrikleri kesip gazı kapatın',
            'Dumanlı yerlerde eğilerek hareket edin',
            'Acil çıkış kapılarını kullanın',
          ],
        ),
      ],
    );
  }

  Widget _buildProcedureCard({
    required String title,
    required List<String> steps,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF003875),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Güvenlik İpuçları',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTipItem(
                  icon: Icons.lightbulb,
                  tip: 'Acil durum çantanızı her zaman hazır tutun',
                ),
                const Divider(height: 16),
                _buildTipItem(
                  icon: Icons.family_restroom,
                  tip: 'Aile iletişim planı hazırlayın',
                ),
                const Divider(height: 16),
                _buildTipItem(
                  icon: Icons.phone_android,
                  tip: 'Acil durum uygulamalarını indirin',
                ),
                const Divider(height: 16),
                _buildTipItem(
                  icon: Icons.location_on,
                  tip: 'Toplanma noktalarınızı bilin',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem({required IconData icon, required String tip}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFF59E0B), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  void _showEmergencyGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Acil Durum Rehberi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: const [
                    Text(
                      'Bu rehber temel acil durum prosedürlerini içerir. '
                      'Daha detaylı bilgi için Tulpars Derneği\'ne başvurun.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      '📋 Temel İlkeler:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Sakin kalmak en önemlidir\n'
                      '• Yardım isteyin ve talimatları takip edin\n'
                      '• Başkalarına yardım etmeye çalışın\n'
                      '• Güvenli bir yere gidin',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNearestCenter() {
    // TODO: Implement location-based nearest center finding
    _showSnackBar('En yakın merkez özelliği yakında eklenecek');
  }
}
