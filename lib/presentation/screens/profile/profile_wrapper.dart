import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'profile_screen.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  String _generateGuestName() {
    final random = Random();
    final number = random.nextInt(9999999) + 1000000;
    return 'Misafir$number';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual auth state from AuthBloc
    final isLoggedIn = false; // Simulated
    final isGuest = true; // Simulated
    final isDemoAdmin = false; // Simulated

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
          backgroundColor: const Color(0xFF003875),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/main'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline,
                size: 100,
                color: Color(0xFF003875),
              ),
              const SizedBox(height: 24),
              const Text(
                'Lütfen Giriş Yapınız',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Profilinizi görüntülemek için\ngiriş yapmanız gerekmektedir',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.login),
                label: const Text('Giriş Yap'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003875),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Hesap Oluştur'),
              ),
            ],
          ),
        ),
      );
    }

    // If guest, show guest profile with random name
    if (isGuest) {
      return _GuestProfileScreen(guestName: _generateGuestName());
    }

    // If demo admin, show full profile
    if (isDemoAdmin) {
      return const ProfileScreen(); // Full profile for demo admin
    }

    // Regular logged-in user
    return const ProfileScreen();
  }
}

class _GuestProfileScreen extends StatelessWidget {
  const _GuestProfileScreen({required this.guestName});

  final String guestName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/main'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF003875).withValues(alpha: 0.1),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF003875),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              guestName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.visibility_off, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Misafir Hesap',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Misafir hesaplar sınırlı özelliklere sahiptir.\nTüm özelliklere erişmek için giriş yapın.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login),
              label: const Text('Giriş Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003875),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.go('/register'),
              icon: const Icon(Icons.person_add),
              label: const Text('Hesap Oluştur'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
