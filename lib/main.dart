import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/auth_service.dart';
import 'core/services/cache_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/bloc/app/app_bloc.dart' as app;
import 'presentation/bloc/auth/auth_bloc.dart' as auth;
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/donations/donations_screen.dart';
import 'presentation/screens/education/education_screen.dart';
import 'presentation/screens/emergency/emergency_screen.dart';
import 'presentation/screens/gallery/gallery_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/membership/membership_screen.dart';
import 'presentation/screens/news/news_screen.dart';
import 'presentation/screens/notifications/notifications_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/operations/operations_screen.dart';
import 'presentation/screens/profile/profile_wrapper.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/sports/sports_screen.dart';
import 'presentation/screens/admin/admin_panel_screen.dart';
import 'presentation/screens/profile/association_profile_screen.dart';

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

  // Initialize auth service
  final authService = AuthService();

  runApp(TulparsApp(authService: authService));
}

class TulparsApp extends StatelessWidget {
  const TulparsApp({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<app.AppBloc>(
          create: (context) => app.AppBloc()..add(app.AppStarted()),
        ),
        BlocProvider<auth.AuthBloc>(
          create: (context) =>
              auth.AuthBloc(authService)..add(auth.AppStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Tulpars Derneği',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        locale: const Locale('tr', 'TR'),
        supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    // Auth routes - NO bottom navigation
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // Main app routes - WITH bottom navigation
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      routes: [
        GoRoute(path: '/main', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/emergency',
          builder: (context, state) => const EmergencyScreen(),
        ),
        GoRoute(
          path: '/donations',
          builder: (context, state) => const DonationsScreen(),
        ),
        GoRoute(
          path: '/membership',
          builder: (context, state) => const MembershipScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileWrapper(),
        ),
        GoRoute(
          path: '/sports',
          builder: (context, state) => const SportsScreen(),
        ),
        GoRoute(
          path: '/education',
          builder: (context, state) => const EducationScreen(),
        ),
        GoRoute(
          path: '/gallery',
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: '/operations',
          builder: (context, state) => const OperationsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(path: '/news', builder: (context, state) => const NewsScreen()),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminPanelScreen(),
        ),
        GoRoute(
          path: '/association',
          builder: (context, state) => const AssociationProfileScreen(),
        ),
      ],
    ),
  ],
  initialLocation: '/',
);
