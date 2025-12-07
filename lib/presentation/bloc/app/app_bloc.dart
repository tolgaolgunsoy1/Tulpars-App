import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/services/auth_service.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  AppBloc() : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<SignOutRequested>(_onSignOutRequested);

    // Listen to authentication state changes
    _authService.authStateChanges.listen((user) {
      add(AuthenticationStatusChanged(user != null));
    });
  }
  final AuthService _authService = AuthService();

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(AppLoading());

    try {
      // Simulate initialization checks
      await Future.delayed(const Duration(seconds: 2));

      // Check if onboarding is completed
      final settingsBox = await Hive.openBox('settings');
      final onboardingCompleted = settingsBox.get(
        'onboarding_completed',
        defaultValue: false,);if (!onboardingCompleted) {
        emit(OnboardingRequired());
        return;
      }

      // Check authentication status
      if (_authService.isSignedIn) {
        emit(AppLoaded());
      } else {
        emit(AuthenticationRequired());
      }
    } catch (e) {
      emit(AppError('Uygulama başlatılırken hata oluştu: $e'));
    }
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AppState> emit,) {
    if (event.isAuthenticated) {
      emit(AppLoaded());
    } else {
      emit(AuthenticationRequired());
    }
  }

  void _onSignOutRequested(
      SignOutRequested event, Emitter<AppState> emit,) async {
    emit(SignOutInProgress());
    try {
      await _authService.signOut();
      emit(AuthenticationRequired());
    } catch (e) {
      emit(AuthenticationError('Çıkış yapılırken hata oluştu: $e'));
    }
  }
}




