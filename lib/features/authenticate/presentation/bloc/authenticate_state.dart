part of 'authenticate_bloc.dart';

abstract class AuthenticateState {}

class AuthenticateInitial extends AuthenticateState {}

class AuthenticateLoading extends AuthenticateState {}

class AuthenticateSuccess extends AuthenticateState {
  final String userId;

  AuthenticateSuccess({required this.userId});
}

class AuthenticateError extends AuthenticateState {
  final String message;

  AuthenticateError(this.message);
}

class Unauthenticated extends AuthenticateState {}
