import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(AppLoading());

    try {
      // Simulate initialization checks
      await Future.delayed(const Duration(seconds: 1));

      // Skip authentication and onboarding checks - go directly to main screen
      emit(AppLoaded());
    } catch (e) {
      emit(AppError('Uygulama başlatılırken hata oluştu: $e'));
    }
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AppState> emit,
  ) {
    if (event.isAuthenticated) {
      emit(AppLoaded());
    } else {
      emit(AuthenticationRequired());
    }
  }

  void _onSignOutRequested(
    SignOutRequested event,
    Emitter<AppState> emit,
  ) async {
    emit(SignOutInProgress());
    try {
      // Clear any stored user data
      final userBox = Hive.box('user_data');
      await userBox.clear();
      emit(AuthenticationRequired());
    } catch (e) {
      emit(AuthenticationError('Çıkış yapılırken hata oluştu: $e'));
    }
  }
}
