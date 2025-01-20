import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<Either<Exception, void>> call() {
    return repository.logout();
  }
}
