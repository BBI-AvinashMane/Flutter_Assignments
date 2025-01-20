import 'package:dartz/dartz.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Exception, User>> login(String email, String password);
  Future<Either<Exception, User>> register(String email, String password);
  Future<Either<Exception, User>> loginWithGoogle();
  Future<Either<Exception, void>> sendPasswordReset(String email);
  Future<Either<Exception, void>> logout();
}
