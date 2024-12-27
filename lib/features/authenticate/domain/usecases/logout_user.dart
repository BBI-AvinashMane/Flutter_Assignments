import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import '../repositories/authenticate_repository.dart';

class LogoutUser implements UseCase<void, NoParams> {
  final AuthenticateRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logoutUser();
  }
}
