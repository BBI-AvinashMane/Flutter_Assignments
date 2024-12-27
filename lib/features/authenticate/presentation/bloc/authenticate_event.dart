import 'package:equatable/equatable.dart';

abstract class AuthenticateEvent extends Equatable {
  const AuthenticateEvent();

  @override
  List<Object?> get props => [];
}

class RegisterUserEvent extends AuthenticateEvent {}

class LoginUserEvent extends AuthenticateEvent {
  final String userId;

  const LoginUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LogoutEvent extends AuthenticateEvent {}
