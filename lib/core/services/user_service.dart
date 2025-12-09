import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';

  // Demo credentials
  static const String demoAdminEmail = 'demo@application.com';
  static const String demoAdminPassword = 'secureDemoPass2023';
  static const String demoAdminUsername = 'demo_admin';

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      throw Exception('Kullanıcı bilgisi alınamadı: $e');
    }
  }

  // Create or update user
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.id).set(
            user.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw Exception('Kullanıcı kaydedilemedi: $e');
    }
  }

  // Update user role (Admin only)
  Future<void> updateUserRole(String userId, UserRole newRole) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'role': newRole.name,
      });
    } catch (e) {
      throw Exception('Kullanıcı rolü güncellenemedi: $e');
    }
  }

  // Check if user has permission
  Future<bool> checkPermission(String userId, Permission permission) async {
    try {
      final user = await getUserById(userId);
      if (user == null) return false;
      return user.hasPermission(permission);
    } catch (e) {
      return false;
    }
  }

  // Initialize demo admin account
  Future<UserModel> initializeDemoAdmin() async {
    try {
      final demoAdmin = UserModel.createDemoAdmin();
      await saveUser(demoAdmin);
      return demoAdmin;
    } catch (e) {
      throw Exception('Demo admin hesabı oluşturulamadı: $e');
    }
  }

  // Check and deactivate expired demo accounts
  Future<void> checkExpiredDemoAccounts() async {
    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('metadata.isDemo', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      for (final doc in snapshot.docs) {
        final user = UserModel.fromJson({...doc.data(), 'id': doc.id});
        if (user.isExpired) {
          await _firestore.collection(_usersCollection).doc(doc.id).update({
            'isActive': false,
            'metadata.deactivatedAt': now.toIso8601String(),
            'metadata.deactivationReason': 'Demo period expired',
          });
        }
      }
    } catch (e) {
      throw Exception('Süresi dolan hesaplar kontrol edilemedi: $e');
    }
  }

  // Get all users (Admin only)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection(_usersCollection).get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Kullanıcılar alınamadı: $e');
    }
  }

  // Get users by role
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final snapshot = await _firestore
          .collection(_usersCollection)
          .where('role', isEqualTo: role.name)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Kullanıcılar alınamadı: $e');
    }
  }

  // Deactivate user (Admin only)
  Future<void> deactivateUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'isActive': false,
        'metadata.deactivatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Kullanıcı devre dışı bırakılamadı: $e');
    }
  }

  // Activate user (Admin only)
  Future<void> activateUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'isActive': true,
        'metadata.activatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Kullanıcı aktif edilemedi: $e');
    }
  }

  // Get demo admin info
  static Map<String, String> getDemoAdminCredentials() {
    return {
      'email': demoAdminEmail,
      'password': demoAdminPassword,
      'username': demoAdminUsername,
    };
  }
}
