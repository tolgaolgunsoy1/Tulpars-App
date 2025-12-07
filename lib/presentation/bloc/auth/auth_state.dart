part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {

  const Authenticated({this.userId, this.email, this.displayName});
  final String? userId;
  final String? email;
  final String? displayName;

  @override
  List<Object> get props => [userId ?? '', email ?? '', displayName ?? ''];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {

  const AuthError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class PasswordResetSent extends AuthState {

  const PasswordResetSent(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}



