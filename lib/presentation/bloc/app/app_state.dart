part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {}

class OnboardingRequired extends AppState {}

class AuthenticationRequired extends AppState {}

class AuthenticationInProgress extends AppState {}

class SignOutInProgress extends AppState {}

class AppError extends AppState {
  const AppError(this.message, {this.title});
  final String message;
  final String? title;

  @override
  List<Object> get props => [message, title ?? ''];
}

class AuthenticationError extends AppState {
  const AuthenticationError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
