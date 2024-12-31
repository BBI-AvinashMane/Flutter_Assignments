part of 'authenticate_bloc.dart';

abstract class AuthenticateEvent {}

class RegisterUserEvent extends AuthenticateEvent {}

class LoginUserEvent extends AuthenticateEvent {
  final String userId;
  

  LoginUserEvent({required this.userId});
}


class LogoutEvent extends AuthenticateEvent {
  final BuildContext context;
   LogoutEvent(this.context);
}
