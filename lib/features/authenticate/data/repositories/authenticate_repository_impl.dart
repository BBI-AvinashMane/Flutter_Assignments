import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
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
      return Left(ServerFailure("${Constants.failedToRegisterUser}$e"));
    }
  }

  @override
  Future<Either<Failure, bool>> loginUser(String userId) async {
    try {
      final isValid = await remoteDataSource.loginUser(userId);
      return Right(isValid);
    } catch (e) {
      return Left(ServerFailure("${Constants.failedToLoginUser}$e"));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      return const Right(null); // No explicit logout logic for now
    } catch (e) {
      return Left(ServerFailure("${Constants.failedToLogoutUser}$e"));
    }
  }
}
