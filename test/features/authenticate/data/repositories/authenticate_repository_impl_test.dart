import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/authenticate/data/datasources/authenticate_remote_data_source.dart';
import 'package:task_manager_firebase/features/authenticate/data/repositories/authenticate_repository_impl.dart';

class MockAuthenticateRemoteDataSource extends Mock
    implements AuthenticateRemoteDataSource {}

void main() {
  late AuthenticateRepositoryImpl repository;
  late MockAuthenticateRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthenticateRemoteDataSource();
    repository = AuthenticateRepositoryImpl(mockRemoteDataSource);
  });

  group('registerUser', () {
    const userId = 'user_1';

    test('should return Right(userId) when registration is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.registerUser())
          .thenAnswer((_) async => userId);

      // Act
      final result = await repository.registerUser();

      // Assert
      expect(result, const Right(userId));
      verify(() => mockRemoteDataSource.registerUser()).called(1);
    });

    test('should return Left(Failure) when registration fails', () async {
      // Arrange
      when(() => mockRemoteDataSource.registerUser())
          .thenThrow(Exception('Registration error'));

      // Act
      final result = await repository.registerUser();

      // Assert
      expect(result, isA<Left<Failure, String>>());
      verify(() => mockRemoteDataSource.registerUser()).called(1);
    });
  });

  group('loginUser', () {
    const userId = 'user_1';

    test('should return Right(true) when login is successful', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginUser(userId))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.loginUser(userId);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRemoteDataSource.loginUser(userId)).called(1);
    });

    test('should return Right(false) when login is unsuccessful', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginUser(userId))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.loginUser(userId);

      // Assert
      expect(result, const Right(false));
      verify(() => mockRemoteDataSource.loginUser(userId)).called(1);
    });

    test('should return Left(Failure) when login throws an exception', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginUser(userId))
          .thenThrow(Exception('Login error'));

      // Act
      final result = await repository.loginUser(userId);

      // Assert
      expect(result, isA<Left<Failure, bool>>());
      verify(() => mockRemoteDataSource.loginUser(userId)).called(1);
    });
  });

  group('logoutUser', () {
    test('should always return Right(void)', () async {
      // Act
      final result = await repository.logoutUser();

      // Assert
      expect(result, const Right(null));
    });

    test('should not throw an exception', () async {
      // Act
      final result = await repository.logoutUser();

      // Assert
      expect(result, isA<Right<Failure, void>>());
    });
  });
}
