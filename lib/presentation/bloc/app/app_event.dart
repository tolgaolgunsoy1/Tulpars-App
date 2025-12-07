part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AppEvent {}

class AuthenticationStatusChanged extends AppEvent {

  const AuthenticationStatusChanged(this.isAuthenticated);
  final bool isAuthenticated;

  @override
  List<Object> get props => [isAuthenticated];
}

class SignOutRequested extends AppEvent {}



