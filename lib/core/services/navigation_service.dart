import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  /// Safe back navigation with fallback
  static void goBack(BuildContext context, {String? fallbackRoute}) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallbackRoute ?? '/main');
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