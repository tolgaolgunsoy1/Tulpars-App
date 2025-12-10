import 'package:flutter/material.dart';
import '../../../core/services/navigation_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _handleGoogleSignIn() {
    // TODO: Google Sign-In entegrasyonu
    debugPrint('Google Sign-In');
  }

  void _handleAppleSignIn() {
    // TODO: Apple Sign-In entegrasyonu
    debugPrint('Apple Sign-In');
  }

  void _handleGuestMode() {
    NavigationService.goToMain(context);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo ve başlık
                _buildHeader(),

                const SizedBox(height: 40),

                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Login Button
                      _buildAuthButton('Giriş Yap', () => NavigationService.goToLogin(context)),

                      const SizedBox(height: 16),

                      // Register Button
                      _buildAuthButton(
                        'Kayıt Ol',
                        () => NavigationService.goToRegister(context),
                        isOutlined: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Sosyal medya girişleri
                _buildSocialLogins(),

                const SizedBox(height: 24),

                // Misafir olarak devam et
                _buildGuestButton(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF003875),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF003875).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/appstore.png',
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'TULPARS',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003875),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hesabınıza Giriş Yapın veya Kayıt Olun',
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('veya', style: TextStyle(color: Color(0xFF64748B))),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 24),
        // Google Sign-In
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _handleGoogleSignIn,
            icon: const Icon(
              Icons.g_mobiledata,
              size: 32,
              color: Color(0xFFDC2626),
            ),
            label: const Text(
              'Google ile Devam Et',
              style: TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Apple Sign-In
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _handleAppleSignIn,
            icon: const Icon(Icons.apple, size: 28, color: Color(0xFF0F172A)),
            label: const Text(
              'Apple ile Devam Et',
              style: TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton(
    String text,
    VoidCallback onPressed, {
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF003875)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003875),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003875),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  Widget _buildGuestButton() {
    return TextButton(
      onPressed: _handleGuestMode,
      child: const Text(
        'Misafir Olarak Devam Et',
        style: TextStyle(
          color: Color(0xFF64748B),
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
