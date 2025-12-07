import 'package:flutter/material.dart';
import 'package:tulpars_app/core/constants/app_constants.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor),
        elevation: 0,
        title: const Text(
          'Üyelik',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Membership Status
              _buildMembershipStatus(),

              const SizedBox(height: 24),

              // Membership Benefits
              _buildMembershipBenefits(),

              const SizedBox(height: 24),

              // Membership Types
              _buildMembershipTypes(),

              const SizedBox(height: 24),

              // How to Join
              _buildHowToJoin(),

              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(AppConstants.primaryColor),
            Color(AppConstants.primaryLightColor)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.primaryColor).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.verified_user,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Aktif Üye',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tulpars Derneği Üyesi',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Üyelik Tarihi: Ocak 2020',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Üyelik Avantajları',
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
                _buildBenefitItem(
                  icon: Icons.search,
                  title: 'Arama-Kurtarma Operasyonları',
                  description: 'Aktif operasyonlara katılma hakkı',
                ),
                const Divider(height: 16),
                _buildBenefitItem(
                  icon: Icons.school,
                  title: 'Ücretsiz Eğitimler',
                  description: 'İlk yardım, arama-kurtarma eğitimleri',
                ),
                const Divider(height: 16),
                _buildBenefitItem(
                  icon: Icons.sports_basketball,
                  title: 'Spor Kulübü',
                  description: 'Gençlik spor faaliyetlerine katılım',
                ),
                const Divider(height: 16),
                _buildBenefitItem(
                  icon: Icons.volunteer_activism,
                  title: 'Gönüllü Çalışmalar',
                  description: 'Sosyal sorumluluk projeleri',
                ),
                const Divider(height: 16),
                _buildBenefitItem(
                  icon: Icons.event,
                  title: 'Etkinlikler',
                  description: 'Dernek etkinliklerine öncelikli katılım',
                ),
                const Divider(height: 16),
                _buildBenefitItem(
                  icon: Icons.card_membership,
                  title: 'Üye Kartı',
                  description: 'Resmi üye kartı ve kimlik',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(AppConstants.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(AppConstants.primaryColor),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Üyelik Türleri',
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
              child: _buildMembershipTypeCard(
                title: 'Bireysel Üye',
                price: '50₺/yıl',
                features: ['Temel eğitimler', 'Etkinlik katılımı', 'Üye kartı'],
                isPopular: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMembershipTypeCard(
                title: 'Aile Üyesi',
                price: '100₺/yıl',
                features: [
                  'Aile katılımı',
                  'Tüm eğitimler',
                  'Öncelikli hizmet'
                ],
                isPopular: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMembershipTypeCard(
                title: 'Kurumsal Üye',
                price: '500₺/yıl',
                features: ['Şirket desteği', 'Kurumsal eğitim', 'Tanıtım'],
                isPopular: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMembershipTypeCard(
                title: 'Onur Üyesi',
                price: 'İletişim',
                features: ['Yaş limiti yok', 'Sembolik üyelik', 'Özel hizmet'],
                isPopular: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembershipTypeCard({
    required String title,
    required String price,
    required List<String> features,
    required bool isPopular,
  }) {
    return Card(
      elevation: isPopular ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPopular
            ? const BorderSide(
                color: Color(AppConstants.primaryColor), width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(AppConstants.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Popüler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 8),
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
              price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPopular
                    ? const Color(AppConstants.primaryColor)
                    : const Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 12),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _handleMembershipSelection(title),
                style: OutlinedButton.styleFrom(
                  side:
                      const BorderSide(color: Color(AppConstants.primaryColor)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Bilgi Al',
                  style: TextStyle(
                    color: Color(AppConstants.primaryColor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowToJoin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nasıl Üye Olunur?',
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
                _buildStepItem(
                  step: 1,
                  title: 'Başvuru Formu',
                  description: 'Online başvuru formunu doldurun',
                ),
                const Divider(height: 16),
                _buildStepItem(
                  step: 2,
                  title: 'Üyelik Aidatı',
                  description: 'Yıllık aidatınızı ödeyin',
                ),
                const Divider(height: 16),
                _buildStepItem(
                  step: 3,
                  title: 'Onay Süreci',
                  description: 'Başvurunuzun onaylanması',
                ),
                const Divider(height: 16),
                _buildStepItem(
                  step: 4,
                  title: 'Üye Kartı',
                  description: 'Üye kartınızı teslim alın',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleJoinNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppConstants.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Şimdi Üye Ol',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required int step,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(AppConstants.primaryColor),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMembershipSelection(String membershipType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$membershipType Üyeliği'),
        content: Text(
          '$membershipType üyeliği hakkında daha fazla bilgi almak için bizimle iletişime geçin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _handleJoinNow() {
    // TODO: Navigate to membership application form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Üyelik başvuru formu yakında eklenecek'),
        backgroundColor: Color(AppConstants.primaryColor),
      ),
    );
  }
}
