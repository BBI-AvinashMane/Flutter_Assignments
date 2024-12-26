import 'package:equatable/equatable.dart';

class AuthenticateEntity extends Equatable {
  final String userId;

  const AuthenticateEntity(this.userId);

  @override
  List<Object?> get props => [userId];
}
