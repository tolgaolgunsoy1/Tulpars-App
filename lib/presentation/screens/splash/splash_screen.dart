import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../bloc/app/app_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animasyon controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animasyon controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Pulse animasyon controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Wave animasyon controller
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Fade animasyonu
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Scale animasyonu
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Rotate animasyonu
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Text fade animasyonu
    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    // Slide animasyonu
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Pulse animasyonu
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Animasyonları başlat
    _startAnimations();
  }

  void _startAnimations() async {
    await _logoController.forward();
    await _textController.forward();
    
    // 6 saniye bekle sonra onboarding'e git
    await Future.delayed(const Duration(seconds: 6));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppError) {
          _showErrorSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF003875),
                Color(0xFF0052A3),
                Color(0xFF003875),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Arka plan animasyonlu dalgalar
              _buildAnimatedWaves(size),

              // Ana içerik
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo bölümü
                    _buildLogo(),

                    const SizedBox(height: 32),

                    // Uygulama adı ve slogan
                    _buildAppInfo(),

                    const SizedBox(height: 64),

                    // Yükleniyor göstergesi
                    _buildLoadingIndicator(),
                  ],
                ),
              ),

              // Alt bilgi
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedWaves(Size size) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Transform.translate(
                offset: Offset(
                  100 * math.sin(_waveController.value * 2 * math.pi),
                  100 * math.cos(_waveController.value * 2 * math.pi),
                ),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Transform.translate(
                offset: Offset(
                  100 * math.cos(_waveController.value * 2 * math.pi),
                  100 * math.sin(_waveController.value * 2 * math.pi),
                ),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _pulseController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Arka plan gradient
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white,
                              Colors.grey.shade50,
                            ],
                          ),
                        ),
                      ),
                      // Logo
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/appstore.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppInfo() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Uygulama adı
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xFFE0E7FF),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Alt başlık
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sivil Savunma',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.medical_services_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Arama Kurtarma',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: Column(
            children: [
              // Custom loading indicator
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Yükleniyor...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _textController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _textFadeAnimation,
            child: Column(
              children: [
                Text(
                  'Güvenli Yarınlar İçin',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'v${AppConstants.appVersion}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'Tekrar Dene',
          textColor: Colors.white,
          onPressed: () {
            context.read<AppBloc>().add(AppStarted());
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
