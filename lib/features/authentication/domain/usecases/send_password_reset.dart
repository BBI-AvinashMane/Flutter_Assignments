import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class SendPasswordReset {
  final AuthRepository repository;

  SendPasswordReset(this.repository);

  Future<Either<Exception, void>> call(String email) {
    return repository.sendPasswordReset(email);
  }
}

