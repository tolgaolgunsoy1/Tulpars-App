enum UserRole {
  guest('Misafir'),
  member('Üye'),
  president('Başkan'),
  admin('Yönetici');

  const UserRole(this.displayName);
  final String displayName;

  int get level {
    switch (this) {
      case UserRole.guest:
        return 0;
      case UserRole.member:
        return 1;
      case UserRole.president:
        return 2;
      case UserRole.admin:
        return 3;
    }
  }

  bool hasAuthorityOver(UserRole other) => level >= other.level;
}

enum Permission {
  viewContent,
  basicSearch,
  comment,
  editProfile,
  viewDetailedContent,
  manageGroups,
  moderate,
  viewReports,
  createEvents,
  manageUsers,
  systemSettings,
  dataAnalytics,
  fullControl,
  manageRoles,
}

class RolePermissions {
  static const Map<UserRole, List<Permission>> permissions = {
    UserRole.guest: [
      Permission.viewContent,
      Permission.basicSearch,
    ],
    UserRole.member: [
      Permission.viewContent,
      Permission.basicSearch,
      Permission.comment,
      Permission.editProfile,
      Permission.viewDetailedContent,
    ],
    UserRole.president: [
      Permission.viewContent,
      Permission.basicSearch,
      Permission.comment,
      Permission.editProfile,
      Permission.viewDetailedContent,
      Permission.manageGroups,
      Permission.moderate,
      Permission.viewReports,
      Permission.createEvents,
    ],
    UserRole.admin: [
      Permission.viewContent,
      Permission.basicSearch,
      Permission.comment,
      Permission.editProfile,
      Permission.viewDetailedContent,
      Permission.manageGroups,
      Permission.moderate,
      Permission.viewReports,
      Permission.createEvents,
      Permission.manageUsers,
      Permission.systemSettings,
      Permission.dataAnalytics,
      Permission.fullControl,
      Permission.manageRoles,
    ],
  };

  static bool hasPermission(UserRole role, Permission permission) {
    return permissions[role]?.contains(permission) ?? false;
  }

  static List<Permission> getPermissions(UserRole role) {
    return permissions[role] ?? [];
  }
}
