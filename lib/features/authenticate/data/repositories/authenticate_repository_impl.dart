
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';

import '../../domain/repositories/authenticate_repository.dart';

import '../datasources/authenticate_remote_data_source.dart';

class AuthenticateRepositoryImpl implements AuthenticateRepository {
  final AuthenticateRemoteDataSource remoteDataSource;

  AuthenticateRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> registerUser() async {
    try {
      final userId = await remoteDataSource.registerUser();
      return Right(userId);
    } catch (e) {
      return Left(ServerFailure("Failed to register user: ${e.toString()}"));// add this line in constant.dart to remove hardcoded message
    }
  }

  @override
  Future<Either<Failure, bool>> loginUser(String userId) async {
    try {
      final isValid = await remoteDataSource.loginUser(userId);
      return Right(isValid);
    } catch (e) {
      return Left(ServerFailure("Failed to login user: ${e.toString()}")); // add this line in constant.dart to remove hardcoded message
    }
  }
}
