
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';

import '../../domain/repositories/authenticate_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class AuthenticateRepositoryImpl implements AuthenticateRepository {
//   final AuthenticateRemoteDataSource remoteDataSource;

//   AuthenticateRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<Either<Failure, String>> registerUser() async {
//     try {
//       final userId = await remoteDataSource.registerUser();
//       return Right(userId);
//     } catch (e) {
//       return Left(ServerFailure("Failed to register user: ${e.toString()}"));// add this line in constant.dart to remove hardcoded message
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> loginUser(String userId) async {
//     try {
//       final isValid = await remoteDataSource.loginUser(userId);
//       return Right(isValid);
//     } catch (e) {
//       return Left(ServerFailure("Failed to login user: ${e.toString()}")); // add this line in constant.dart to remove hardcoded message
//     }
//   }
// }

class AuthenticateRepositoryImpl implements AuthenticateRepository {
  final SharedPreferences preferences;

  static const String loggedInUserKey = "loggedInUser";

  AuthenticateRepositoryImpl(this.preferences);

  @override
  Future<Either<Failure, String>> registerUser() async {
    try {
      // Simulate user registration and return a user ID
      const userId = "generated_user_id"; // Replace with actual implementation
      preferences.setString(loggedInUserKey, userId);
      return const Right(userId);
    } catch (e) {
      return const Left(ServerFailure("Failed to register user"));
    }
  }

  @override
  Future<Either<Failure, bool>> loginUser(String userId) async {
    try {
      // Simulate user login and validation
      final isValid = userId == preferences.getString(loggedInUserKey);
      if (isValid) {
        preferences.setString(loggedInUserKey, userId); // Save user ID
      }
      return Right(isValid);
    } catch (e) {
      return const Left(ServerFailure("Failed to log in user"));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      preferences.remove(loggedInUserKey); // Clear logged-in user
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure("Failed to log out user"));
    }
  }
}
