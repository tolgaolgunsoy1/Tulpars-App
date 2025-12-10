import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authService) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthService _authService;

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = _authService.currentUser;
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const AuthError(message: 'Oturum kontrolü sırasında hata oluştu'));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        event.email,
        event.password,
      );

      if (userCredential.user != null) {
        emit(Authenticated(user: userCredential.user!));
      } else {
        emit(const AuthError(message: 'Giriş yapılamadı'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(const AuthError(message: 'Beklenmeyen bir hata oluştu'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );

      // Update display name if provided
      if (event.name.isNotEmpty && userCredential.user != null) {
        await _authService.updateProfile(displayName: event.name);
        // Reload user to get updated profile
        await userCredential.user!.reload();
        final updatedUser = _authService.currentUser;
        if (updatedUser != null) {
          emit(Authenticated(user: updatedUser));
          return;
        }
      }

      if (userCredential.user != null) {
        emit(Authenticated(user: userCredential.user!));
      } else {
        emit(const AuthError(message: 'Kayıt işlemi başarısız'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(const AuthError(message: 'Beklenmeyen bir hata oluştu'));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential?.user != null) {
        emit(Authenticated(user: userCredential!.user!));
      } else {
        emit(const Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(const AuthError(message: 'Google ile giriş yapılamadı'));
    }
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _authService.signInWithApple();
      if (userCredential?.user != null) {
        emit(Authenticated(user: userCredential!.user!));
      } else {
        emit(const Unauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(const AuthError(message: 'Apple ile giriş yapılamadı'));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authService.sendPasswordResetEmail(event.email);
      emit(PasswordResetSent(email: event.email));
      // Optionally return to Unauthenticated after a delay
      await Future.delayed(const Duration(seconds: 2));
      emit(const Unauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(const AuthError(message: 'Şifre sıfırlama e-postası gönderilemedi'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authService.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(const AuthError(message: 'Çıkış yapılırken hata oluştu'));
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
      case 'wrong-password':
        return 'E-posta veya şifre hatalı';
      case 'invalid-credential':
        return 'Giriş bilgileri geçersiz';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanılıyor';
      case 'weak-password':
        return 'Şifre çok zayıf. En az 8 karakter, harf ve rakam kullanın';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi formatı';
      case 'user-disabled':
        return 'Bu hesap güvenlik nedeniyle devre dışı bırakılmış';
      case 'too-many-requests':
        return 'Çok fazla başarısız deneme. 15 dakika sonra tekrar deneyin';
      case 'operation-not-allowed':
        return 'Bu giriş yöntemi şu anda aktif değil';
      case 'network-request-failed':
        return 'İnternet bağlantınızı kontrol edin';
      case 'requires-recent-login':
        return 'Güvenlik için tekrar giriş yapmanız gerekiyor';
      case 'account-exists-with-different-credential':
        return 'Bu e-posta farklı bir yöntemle kayıtlı';
      case 'invalid-verification-code':
        return 'Doğrulama kodu geçersiz';
      case 'invalid-verification-id':
        return 'Doğrulama işlemi geçersiz';
      case 'missing-email':
        return 'E-posta adresi gerekli';
      case 'missing-password':
        return 'Şifre gerekli';
      default:
        return 'Giriş yapılırken bir hata oluştu. Lütfen tekrar deneyin';
    }
  }
}
