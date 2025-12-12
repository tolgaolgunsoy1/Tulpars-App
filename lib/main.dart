import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/services/cache_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/bloc/app/app_bloc.dart' as app;
import 'presentation/screens/about/about_screen.dart';
import 'presentation/screens/admin/admin_panel_screen.dart';
import 'presentation/screens/donations/donations_screen.dart';
import 'presentation/screens/education/education_screen.dart';
import 'presentation/screens/emergency/emergency_screen.dart';
import 'presentation/screens/gallery/gallery_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/membership/membership_screen.dart';
import 'presentation/screens/news/news_screen.dart';
import 'presentation/screens/notifications/notifications_screen.dart';
import 'presentation/screens/operations/operations_screen.dart';
import 'presentation/screens/profile/association_profile_screen.dart';
import 'presentation/screens/profile/profile_wrapper.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/sports/sports_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI
  await _configureSystemUI();

  // Initialize services
  await _initializeServices();

  runApp(const TulparsApp());
}

/// Configure system UI appearance
Future<void> _configureSystemUI() async {
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}

/// Initialize all app services
Future<void> _initializeServices() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    developer.log('Firebase initialized', name: 'TulparsApp');

    // Initialize Hive
    await Hive.initFlutter();
    developer.log('Hive initialized', name: 'TulparsApp');

    // Open Hive boxes with error handling
    await Future.wait([
      Hive.openBox('settings'),
      Hive.openBox('user_data'),
      Hive.openBox('cache'),
    ]);
    developer.log('Hive boxes opened', name: 'TulparsApp');

    // Initialize cache service
    final cacheService = CacheService();
    await cacheService.init();
    developer.log('Cache service initialized', name: 'TulparsApp');

    // Initialize connectivity service
    final connectivityService = ConnectivityService();
    await connectivityService.initialize();
    developer.log('Connectivity service initialized', name: 'TulparsApp');

    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.initialize();
    developer.log('Notification service initialized', name: 'TulparsApp');
  } catch (e, stack) {
    developer.log(
      'Service initialization error',
      error: e,
      stackTrace: stack,
      name: 'TulparsApp',
    );
    rethrow;
  }
}

class TulparsApp extends StatefulWidget {
  const TulparsApp({super.key});

  @override
  State<TulparsApp> createState() => _TulparsAppState();
}

class _TulparsAppState extends State<TulparsApp> with WidgetsBindingObserver {
  late final GoRouter _router;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _router = _createRouter();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    developer.log('App lifecycle state: $state', name: 'TulparsApp');

    switch (state) {
      case AppLifecycleState.resumed:
        // App resumed - refresh data if needed
        break;
      case AppLifecycleState.inactive:
        // App inactive
        break;
      case AppLifecycleState.paused:
        // App paused - save state if needed
        break;
      case AppLifecycleState.detached:
        // App detached
        break;
      case AppLifecycleState.hidden:
        // App hidden
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<app.AppBloc>(
          create: (context) => app.AppBloc()..add(app.AppStarted()),
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final currentRoute =
              _router.routerDelegate.currentConfiguration.uri.toString();

          // If on main screen, show exit confirmation with double-tap
          if (currentRoute == '/main') {
            final now = DateTime.now();
            final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
                _lastBackPressTime == null ||
                    now.difference(_lastBackPressTime!) >
                        const Duration(seconds: 2);

            if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
              _lastBackPressTime = now;
              _showExitSnackBar(context);
              return;
            }

            await SystemNavigator.pop();
          } else {
            // For other screens, just go back
            _router.pop();
          }
        },
        child: MaterialApp.router(
          title: 'Tulpars Derneği',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          locale: const Locale('tr', 'TR'),
          supportedLocales: const [
            Locale('tr', 'TR'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }

  void _showExitSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Çıkmak için tekrar geri basın',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF003875),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  GoRouter _createRouter() {
    return GoRouter(
      routes: _buildRoutes(),
      initialLocation: '/splash',
      errorBuilder: _buildErrorScreen,
      redirect: _handleRedirect,
      observers: [
        // Add navigation observers for analytics if needed
        _NavigationObserver(),
      ],
    );
  }

  List<RouteBase> _buildRoutes() {
    return [
      // Splash screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Onboarding screen
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Login screen
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Main app routes - WITH bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/main',
            builder: (context, state) => const SizedBox(),
          ),
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
          GoRoute(
            path: '/news',
            builder: (context, state) => const NewsScreen(),
          ),
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
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
    ];
  }

  Widget _buildErrorScreen(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfa Bulunamadı'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/main');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003875),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sayfa Bulunamadı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Aradığınız sayfa mevcut değil veya taşınmış olabilir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/main'),
              icon: const Icon(Icons.home),
              label: const Text('Ana Sayfaya Dön'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003875),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final location = state.uri.toString();

    developer.log('Navigation to: $location', name: 'TulparsApp');

    // Add authentication checks here if needed
    // Example:
    // if (requiresAuth && !isAuthenticated) {
    //   return '/auth';
    // }

    return null; // Allow navigation
  }
}

/// Navigation observer for logging and analytics
class _NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    developer.log(
      'Pushed: ${route.settings.name}',
      name: 'Navigation',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    developer.log(
      'Popped: ${route.settings.name}',
      name: 'Navigation',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    developer.log(
      'Replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
      name: 'Navigation',
    );
  }
}
