import 'package:equatable/equatable.dart';

abstract class AuthenticateState extends Equatable {
  const AuthenticateState();

  @override
  List<Object?> get props => [];
}

class AuthenticateInitial extends AuthenticateState {}

class AuthenticateLoading extends AuthenticateState {}

class AuthenticateSuccess extends AuthenticateState {
  final String userId;

  const AuthenticateSuccess(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AuthenticateError extends AuthenticateState {
  final String message;

  const AuthenticateError(this.message);

  @override
  List<Object?> get props => [message];
}

class Unauthenticated extends AuthenticateState {}

class Authenticated extends AuthenticateState {
  final String userId;
  const Authenticated(this.userId);
}
