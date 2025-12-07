import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc({AuthService? authService})
      : _authService = authService ?? AuthService(),
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);

    // Listen to authentication state changes
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        add(const AuthStatusChanged(true));
      } else {
        add(const AuthStatusChanged(false));
      }
    });
  }
  final AuthService _authService;

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    final user = _authService.currentUser;
    if (user != null) {
      emit(Authenticated(
        userId: user.uid,
        email: user.email,
        displayName: user.displayName,),);
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authService.signInWithEmailAndPassword(
        event.email,
        event.password,);emit(Authenticated(
        userId: result.user?.uid,
        email: result.user?.email,
        displayName: result.user?.displayName,),);
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit,) async {
    emit(AuthLoading());
    try {
      final result = await _authService.createUserWithEmailAndPassword(
        event.email,
        event.password,);// Update user profile
      final fullName = '${event.name} ${event.surname}';
      await _authService.updateProfile(displayName: fullName);

      emit(Authenticated(
        userId: result.user?.uid,
        email: result.user?.email,
        displayName: fullName,),);
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthState> emit,) async {
    emit(AuthLoading());
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        emit(Authenticated(
          userId: result.user?.uid,
          email: result.user?.email,
          displayName: result.user?.displayName,),);
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onAppleSignInRequested(
      AppleSignInRequested event, Emitter<AuthState> emit,) async {
    emit(AuthLoading());
    try {
      final result = await _authService.signInWithApple();
      if (result != null) {
        emit(Authenticated(
          userId: result.user?.uid,
          email: result.user?.email,
          displayName: result.user?.displayName,),);
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onPasswordResetRequested(
      PasswordResetRequested event, Emitter<AuthState> emit,) async {
    emit(AuthLoading());
    try {
      await _authService.sendPasswordResetEmail(event.email);
      emit(PasswordResetSent(event.email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit,) async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.isAuthenticated) {
      final user = _authService.currentUser;
      if (user != null) {
        emit(Authenticated(
          userId: user.uid,
          email: user.email,
          displayName: user.displayName,),);
      }
    } else {
      emit(Unauthenticated());
    }
  }
}




