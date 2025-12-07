part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  const LoginRequested({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  const RegisterRequested({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.password,
  });
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String password;

  @override
  List<Object> get props => [name, surname, email, phone, password];
}

class GoogleSignInRequested extends AuthEvent {}

class AppleSignInRequested extends AuthEvent {}

class PasswordResetRequested extends AuthEvent {
  const PasswordResetRequested({required this.email});
  final String email;

  @override
  List<Object> get props => [email];
}

class SignOutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged(this.isAuthenticated);
  final bool isAuthenticated;

  @override
  List<Object> get props => [isAuthenticated];
}
