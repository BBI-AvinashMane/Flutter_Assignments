import 'package:purchaso/features/authentication/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

class AuthLoggedOut extends AuthState {}
