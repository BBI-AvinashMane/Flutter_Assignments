// import 'package:equatable/equatable.dart';

// abstract class AuthenticateEvent extends Equatable {
//   const AuthenticateEvent();

//   @override
//   List<Object?> get props => [];
// }

// class RegisterUserEvent extends AuthenticateEvent {}

// class LoginUserEvent extends AuthenticateEvent {
//   final String userId;

//   const LoginUserEvent(this.userId, {required String userId});

//   @override
//   List<Object?> get props => [userId];
// }

// class LogoutEvent extends AuthenticateEvent {}
part of 'authenticate_bloc.dart';

abstract class AuthenticateEvent {}

class RegisterUserEvent extends AuthenticateEvent {}

class LoginUserEvent extends AuthenticateEvent {
  final String userId;

  LoginUserEvent({required this.userId});
}

class LogoutEvent extends AuthenticateEvent {}

