import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';

import '../repositories/authenticate_repository.dart';

class RegisterUser implements UseCase<String, NoParams> {
  final AuthenticateRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.registerUser();
  }
}
