import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding sayfaları
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Tulpars\'a Hoş Geldiniz',
      description:
          'Sivil savunma, arama-kurtarma ve sosyal dayanışma için buradayız. Acil durumlarda topluma hizmet etmek için eğitimli gönüllülerimizle çalışıyoruz.',
      icon: Icons.emergency,
      color: const Color(AppConstants.primaryColor),
    ),
    OnboardingPage(
      title: 'Birlikte Daha Güçlüyüz',
      description:
          'Eğitimler, spor faaliyetleri, operasyonlar ve sosyal sorumluluk projeleri ile topluma değer katıyoruz.',
      icon: Icons.group,
      color: const Color(AppConstants.primaryLightColor),
    ),
    OnboardingPage(
      title: 'Siz de Aramıza Katılın',
      description:
          'Gönüllü ol, bağış yap veya etkinliklerimizi takip et. Her katkı değerlidir ve fark yaratır.',
      icon: Icons.volunteer_activism,
      color: const Color(AppConstants.accentColor),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToLogin() async {
    // SharedPreferences'a ilk açılış kaydedilecek
    final settingsBox = await Hive.openBox('settings');
    await settingsBox.put('onboarding_completed', true);

    if (mounted) {
      context.go('/auth');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Üst kısım - Atla butonu
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60), // Boşluk için
                  // Tulpars logo/text
                  const Text(
                    'TULPARS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003875),
                      letterSpacing: 1.5,
                    ),
                  ),
                  // Atla butonu
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text(
                      'Atla',
                      style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            ),
            // PageView - Swipe edilebilir sayfalar
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            // Alt kısım - Göstergeler ve buton
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Sayfa göstergeleri (dots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      _buildDot,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // İleri/Başla butonu
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'Başla'
                                : 'İleri',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == _pages.length - 1
                                ? Icons.check_circle_outline
                                : Icons.arrow_forward,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // İkon/Görsel alanı
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 100, color: page.color),
          ),
          const SizedBox(height: 48),
          // Başlık
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: page.color,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          // Açıklama
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? _pages[_currentPage].color : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Onboarding sayfa modeli
class OnboardingPage {
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
