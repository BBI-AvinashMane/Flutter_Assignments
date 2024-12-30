import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';


abstract class AuthenticateRepository {
  /// Registers a user and returns the generated user ID.
  Future<Either<Failure, String>> registerUser();

  /// Logs in a user and returns true if the user exists.
  Future<Either<Failure, bool>> loginUser(String userId);

  /// Logs out the current user.
  Future<Either<Failure, void>> logoutUser();
}
