import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

class PermissionGuard extends StatelessWidget {
  const PermissionGuard({
    super.key,
    required this.user,
    required this.permission,
    required this.child,
    this.fallback,
  });

  final UserModel? user;
  final Permission permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (user == null || !user!.hasPermission(permission)) {
      return fallback ?? const SizedBox.shrink();
    }
    return child;
  }
}

class RoleGuard extends StatelessWidget {
  const RoleGuard({
    super.key,
    required this.user,
    required this.minimumRole,
    required this.child,
    this.fallback,
  });

  final UserModel? user;
  final UserRole minimumRole;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (user == null || !user!.role.hasAuthorityOver(minimumRole)) {
      return fallback ?? const SizedBox.shrink();
    }
    return child;
  }
}

class UnauthorizedWidget extends StatelessWidget {
  const UnauthorizedWidget({
    super.key,
    this.message = 'Bu içeriği görüntüleme yetkiniz yok',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
