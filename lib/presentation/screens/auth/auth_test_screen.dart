import 'package:flutter/material.dart';
import '../../../core/services/navigation_service.dart';

class AuthTestScreen extends StatelessWidget {
  const AuthTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Test'),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kimlik Doğrulama Test Ekranı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003875),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Test Auth Screen
            ElevatedButton(
              onPressed: () => NavigationService.goToAuth(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003875),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Auth Ekranına Git'),
            ),
            
            const SizedBox(height: 16),
            
            // Test Login Screen
            ElevatedButton(
              onPressed: () => NavigationService.goToLogin(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Login Ekranına Git'),
            ),
            
            const SizedBox(height: 16),
            
            // Test Register Screen
            ElevatedButton(
              onPressed: () => NavigationService.goToRegister(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Register Ekranına Git'),
            ),
            
            const SizedBox(height: 16),
            
            // Test Main Screen
            ElevatedButton(
              onPressed: () => NavigationService.goToMain(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ana Ekrana Git'),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Bu ekran auth akışını test etmek için oluşturulmuştur.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}