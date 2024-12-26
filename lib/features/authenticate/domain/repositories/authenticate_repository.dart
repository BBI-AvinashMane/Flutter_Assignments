import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';


abstract class AuthenticateRepository {
  Future<Either<Failure, String>> registerUser();
  Future<Either<Failure, bool>> loginUser(String userId);
}
