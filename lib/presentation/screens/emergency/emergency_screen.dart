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
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emergency,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'TÜRKİYE ACİL DURUM',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'TEK NUMARA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          // Big 112 Call Button - Centered
          Center(
            child: InkWell(
              onTap: () => _makePhoneCall('112'),
              borderRadius: BorderRadius.circular(60),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 36,
                      color: Color(0xFFDC2626),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '112',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Polis • İtfaiye • Sağlık • AFAD\nTüm acil servisler tek numarada',
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoButton(
            icon: Icons.emergency,
            label: 'Tulpars\nAcil',
            color: const Color(0xFF003875),
            onTap: () => _makePhoneCall(AppConstants.tulparsEmergency),
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
                      '112 Türkiye\'nin birleşik acil durum numarasıdır. '
                      'Tüm acil durumlar için tek numara kullanın.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      '112\'yi Ne Zaman Arayın:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Yaşamı tehdit eden durumlar\n'
                      '• Yangın, kaza, suç durumları\n'
                      '• Doğal afetler (deprem, sel vb.)\n'
                      '• Acil tıbbi müdahale gereken durumlar\n'
                      '• Arama-kurtarma gereken durumlar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Arama Sırasında:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Sakin olun ve net konuşun\n'
                      '• Konumunuzu tam olarak belirtin\n'
                      '• Durumu kısaca açıklayın\n'
                      '• Operatörün sorularını yanıtlayın\n'
                      '• Talimatları dikkatle dinleyin',
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
