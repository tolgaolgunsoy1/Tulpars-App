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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2) vsync: this,);_fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn));_scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));_animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is OnboardingRequired) {
          context.go('/onboarding');
        } else if (state is AuthenticationRequired) {
          context.go('/auth');
        } else if (state is AppLoaded) {
          context.go('/main');
        } else if (state is AppError) {
          // Show error and retry option
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message) backgroundColor: const Color(0xFFDC2626) action: SnackBarAction(
                label: 'Tekrar Dene',
                textColor: Colors.white,
                onPressed: () {
                  // Retry app initialization
                  context.read<AppBloc>().add(AppStarted());
                },),),);}
      },
      child: Scaffold(
        backgroundColor: const Color(AppConstants.primaryColor) body: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo placeholder - replace with actual logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2) blurRadius: 20,
                              offset: const Offset(0, 10)),],), child: const Icon(
                          Icons.shield,
                          size: 60,
                          color: Color(AppConstants.primaryColor)),),const SizedBox(height: 24)const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,),),const SizedBox(height: 8)Text(
                        'Sivil Savunma • Arama Kurtarma',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8)), textAlign: TextAlign.center,),const SizedBox(height: 48)const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),],),),);},),),),);}
}






