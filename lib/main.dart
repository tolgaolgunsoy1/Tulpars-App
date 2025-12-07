import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/cache_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/bloc/app/app_bloc.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/donations/donations_screen.dart';
import 'presentation/screens/education/education_screen.dart';
import 'presentation/screens/emergency/emergency_screen.dart';
import 'presentation/screens/gallery/gallery_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/membership/membership_screen.dart';
import 'presentation/screens/notifications/notifications_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/operations/operations_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/sports/sports_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize local storage boxes
  await Hive.openBox('settings');
  await Hive.openBox('user_data');

  // Initialize cache service
  final cacheService = CacheService();
  await cacheService.init();

  // Initialize connectivity service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const TulparsApp());
}

class TulparsApp extends StatelessWidget {
  const TulparsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBloc()..add(AppStarted()),),BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthStarted()),),],child: MaterialApp.router(
        title: 'Tulpars Derneği',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        locale: const Locale('tr', 'TR'), supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],),);}
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),),GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),),GoRoute(path: '/main', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/emergency',
        builder: (context, state) => const EmergencyScreen(),),
    GoRoute(
        path: '/donations',
        builder: (context, state) => const DonationsScreen(),),
    GoRoute(
        path: '/membership',
        builder: (context, state) => const MembershipScreen(),),
    GoRoute(
        path: '/profile', builder: (context, state) => const ProfileScreen(),),
    GoRoute(path: '/sports', builder: (context, state) => const SportsScreen()),
    GoRoute(
        path: '/education',
        builder: (context, state) => const EducationScreen(),),
    GoRoute(
        path: '/gallery', builder: (context, state) => const GalleryScreen(),),
    GoRoute(
        path: '/operations',
        builder: (context, state) => const OperationsScreen(),),
    GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),),
    // Add more routes here as screens are implemented
  ],
  initialLocation: '/',);



