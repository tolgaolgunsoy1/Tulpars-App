import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tulpars_app/core/constants/app_constants.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _donationOptions = [
    {
      'title': 'Aylık Bağış',
      'description': 'Düzenli aylık destek',
      'amounts': ['50₺', '100₺', '250₺', '500₺'],
      'icon': Icons.repeat,
      'color': const Color(0xFF003875),
    },
    {
      'title': 'Tek Seferlik Bağış',
      'description': 'Bir defalık destek',
      'amounts': ['100₺', '250₺', '500₺', '1000₺'],
      'icon': Icons.favorite,
      'color': const Color(0xFFDC2626),
    },
    {
      'title': 'Eşya Bağışı',
      'description': 'Kıyafet, battaniye, gıda',
      'amounts': [],
      'icon': Icons.inventory,
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Gönüllü Ol',
      'description': 'Zamanını bağışla',
      'amounts': [],
      'icon': Icons.volunteer_activism,
      'color': const Color(0xFF10B981),
    },
  ];

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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackBar('Bağlantı açılamadı');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
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
        backgroundColor: const Color(0xFF003875),
        elevation: 0,
        title: const Text(
          'Bağış Yap',
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
              // Header Section
              _buildHeader(),

              const SizedBox(height: 24),

              // Impact Section
              _buildImpactSection(),

              const SizedBox(height: 32),

              // Donation Options
              _buildDonationOptions(),

              const SizedBox(height: 32),

              // Contact Information
              _buildContactInfo(),

              const SizedBox(height: 80), // Bottom padding
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
            color: const Color(0xFF003875).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.volunteer_activism,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Destekleriniz\nHayat Kurtarıyor',
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
            'Tulpars Derneği\'ne yaptığınız bağışlar\narama-kurtarma operasyonlarını destekliyor',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bağışlarınızın Etkisi',
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
              child: _buildImpactCard(
                icon: Icons.search,
                title: 'Arama-Kurtarma',
                description: 'Profesyonel ekipman ve eğitim',
                color: const Color(0xFFDC2626),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildImpactCard(
                icon: Icons.school,
                title: 'Eğitim',
                description: 'Gönüllü eğitim programları',
                color: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildImpactCard(
                icon: Icons.sports_basketball,
                title: 'Gençlik Spor',
                description: 'Spor faaliyetleri desteği',
                color: const Color(0xFF003875),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildImpactCard(
                icon: Icons.people,
                title: 'Toplum Desteği',
                description: 'Sosyal yardım projeleri',
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImpactCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bağış Seçenekleri',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        ..._donationOptions.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildDonationOptionCard(option),
            )),
      ],
    );
  }

  Widget _buildDonationOptionCard(Map<String, dynamic> option) {
    final amounts = option['amounts'] as List<String>;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    color: option['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    option['icon'],
                    color: option['color'],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (amounts.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: amounts
                    .map((amount) => _buildAmountButton(amount))
                    .toList(),
              ),
            ] else ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleSpecialDonation(option['title']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: option['color'],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    option['title'] == 'Eşya Bağışı'
                        ? 'İletişim Bilgileri'
                        : 'Başvur',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    return OutlinedButton(
      onPressed: () => _handleDonation(amount),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF003875)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        amount,
        style: const TextStyle(
          color: Color(0xFF003875),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'İletişim Bilgileri',
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
                _buildContactItem(
                  icon: Icons.phone,
                  title: 'Telefon',
                  value: AppConstants.tulparsEmergency,
                  onTap: () => _makePhoneCall(AppConstants.tulparsEmergency),
                ),
                const Divider(height: 16),
                _buildContactItem(
                  icon: Icons.email,
                  title: 'E-posta',
                  value: 'bagis@tulpars.org.tr',
                  onTap: () => _launchURL('mailto:bagis@tulpars.org.tr'),
                ),
                const Divider(height: 16),
                _buildContactItem(
                  icon: Icons.language,
                  title: 'Website',
                  value: AppConstants.websiteUrl,
                  onTap: () => _launchURL(AppConstants.websiteUrl),
                ),
                const Divider(height: 16),
                _buildContactItem(
                  icon: Icons.location_on,
                  title: 'Adres',
                  value: 'Tulpars Derneği Merkezi\nKayseri, Türkiye',
                  onTap: () => _showLocation(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Tüm bağışlar vergi muafiyeti kapsamındadır. Bağış makbuzu düzenlenir.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF92400E),
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

  void _handleDonation(String amount) {
    // Remove currency symbol and parse amount
    final numericAmount = amount.replaceAll('₺', '');
    _showSuccessSnackBar('$amount bağışınız için teşekkür ederiz!');
    // TODO: Implement actual donation flow
  }

  void _handleSpecialDonation(String type) {
    switch (type) {
      case 'Eşya Bağışı':
        _makePhoneCall(AppConstants.tulparsEmergency);
        break;
      case 'Gönüllü Ol':
        _launchURL('${AppConstants.websiteUrl}/gonullu-ol');
        break;
    }
  }

  void _showLocation() {
    // TODO: Open maps or show location details
    _showSnackBar('Harita özelliği yakında eklenecek');
  }
}
