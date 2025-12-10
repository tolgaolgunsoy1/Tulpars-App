import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Safe back navigation with fallback
  static void goBack(BuildContext context, {String? fallbackRoute}) {
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    
    // Ana sayfadaysa fallback route'a git
    if (currentLocation == '/main') {
      if (fallbackRoute != null) {
        context.go(fallbackRoute);
      }
      return;
    }
    
    // Normal back navigation
    if (context.canPop()) {
      context.pop();
    } else {
      // Stack boşsa ana sayfaya git
      context.go(fallbackRoute ?? '/main');
    }
  }

  /// Navigate to previous tab or main screen
  static void goToPreviousTab(BuildContext context) {
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    
    // Tab sırasına göre önceki tab'a git
    switch (currentLocation) {
      case '/news':
        context.go('/main');
        break;
      case '/membership':
        context.go('/news');
        break;
      case '/sports':
        context.go('/membership');
        break;
      case '/profile':
        context.go('/sports');
        break;
      default:
        context.go('/main');
    }
  }

  /// Navigate to next tab
  static void goToNextTab(BuildContext context) {
    final currentLocation = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    
    // Tab sırasına göre sonraki tab'a git
    switch (currentLocation) {
      case '/main':
        context.go('/news');
        break;
      case '/news':
        context.go('/membership');
        break;
      case '/membership':
        context.go('/sports');
        break;
      case '/sports':
        context.go('/profile');
        break;
      case '/profile':
        context.go('/main');
        break;
      default:
        context.go('/main');
    }
  }

  /// Navigate to auth flow
  static void goToAuth(BuildContext context) {
    context.go('/auth');
  }

  /// Navigate to login
  static void goToLogin(BuildContext context) {
    context.go('/login');
  }

  /// Navigate to register
  static void goToRegister(BuildContext context) {
    context.go('/register');
  }

  /// Navigate to main app
  static void goToMain(BuildContext context) {
    context.go('/main');
  }

  /// Navigate to profile
  static void goToProfile(BuildContext context) {
    context.go('/profile');
  }

  /// Navigate to association profile
  static void goToAssociation(BuildContext context) {
    context.go('/association');
  }

  /// Show error dialog
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle authentication state changes
  static void handleAuthStateChange(BuildContext context, bool isAuthenticated) {
    if (isAuthenticated) {
      goToMain(context);
    } else {
      goToAuth(context);
    }
  }

  /// Navigate with replacement (clears navigation stack)
  static void goAndReplace(BuildContext context, String route) {
    context.go(route);
  }

  /// Push route (adds to navigation stack)
  static void push(BuildContext context, String route) {
    context.push(route);
  }
}