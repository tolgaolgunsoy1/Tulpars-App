part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class PasswordResetSent extends AuthState {
  const PasswordResetSent({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}
