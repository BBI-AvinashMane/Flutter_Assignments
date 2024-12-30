import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import '../repositories/authenticate_repository.dart';

class LoginUser implements UseCase<bool, String> {
  final AuthenticateRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(String userId) async {
    return repository.loginUser(userId);
  }
}
