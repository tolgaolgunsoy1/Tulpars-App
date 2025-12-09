import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google ile giriş yapılırken hata oluştu: $e');
    }
  }

  // Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final result = await _auth.signInWithCredential(oauthCredential);
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Apple ile giriş yapılırken hata oluştu: $e');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Çıkış yapılırken hata oluştu: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      throw Exception('Profil güncellenirken hata oluştu: $e');
    }
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı.');
      case 'wrong-password':
        return Exception('Şifre yanlış.');
      case 'email-already-in-use':
        return Exception('Bu e-posta adresi zaten kullanılıyor.');
      case 'weak-password':
        return Exception('Şifre çok zayıf. Daha güçlü bir şifre seçin.');
      case 'invalid-email':
        return Exception('Geçersiz e-posta adresi.');
      case 'user-disabled':
        return Exception('Bu hesap devre dışı bırakılmış.');
      case 'operation-not-allowed':
        return Exception('Bu işlem şu anda kullanılamıyor.');
      case 'requires-recent-login':
        return Exception('Bu işlem için tekrar giriş yapmanız gerekiyor.');
      case 'too-many-requests':
        return Exception(
          'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin.',
        );
      default:
        return Exception('Bir hata oluştu: ${e.message}');
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Get user ID token
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  // Reload user data
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }
}
