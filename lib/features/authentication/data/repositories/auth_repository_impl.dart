import 'package:dartz/dartz.dart';
import 'package:purchaso/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:purchaso/features/authentication/domain/entities/user.dart';
import 'package:purchaso/features/authentication/domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.loginWithEmailAndPassword(email, password);
      return Right(User(email: user.email!, username: user.email!.split('@')[0]));
    } catch (e) {
      return Left(Exception('Login failed: $e'));
    }
  }

  @override
  Future<Either<Exception, User>> register(String email, String password) async {
    try {
      final user = await remoteDataSource.registerWithEmailAndPassword(email, password);
      return Right(User(email: user.email!, username: user.email!.split('@')[0]));
    } catch (e) {
      return Left(Exception('Registration failed: $e'));
    }
  }

  @override
  Future<Either<Exception, User>> loginWithGoogle() async {
    try {
      final user = await remoteDataSource.loginWithGoogle();
      return Right(User(email: user.email!, username: user.email!.split('@')[0]));
    } catch (e) {
      return Left(Exception('Google login failed: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> sendPasswordReset(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Password reset failed: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Logout failed: $e'));
    }
  }
}
