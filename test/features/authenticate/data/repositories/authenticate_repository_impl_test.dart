import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/authenticate/data/datasources/authenticate_remote_data_source.dart';
import 'package:task_manager_firebase/features/authenticate/data/repositories/authenticate_repository_impl.dart';

class MockAuthenticateRemoteDataSource extends Mock implements AuthenticateRemoteDataSource {}

void main() {
  late MockAuthenticateRemoteDataSource mockRemoteDataSource;
  late AuthenticateRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthenticateRemoteDataSource();
    repository = AuthenticateRepositoryImpl(mockRemoteDataSource);
  });

  group('registerUser', () {
    test('should return user ID on success', () async {
      // Arrange
      const userId = 'user_1';
      when(() => mockRemoteDataSource.registerUser()).thenAnswer((_) async => userId);

      // Act
      final result = await repository.registerUser();

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => ''), userId);
    });

    test('should return failure on exception', () async {
      // Arrange
      when(() => mockRemoteDataSource.registerUser()).thenThrow(Exception('Error'));

      // Act
      final result = await repository.registerUser();

      // Assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('loginUser', () {
    const userId = 'user_1';

    test('should return true if user exists', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginUser(userId)).thenAnswer((_) async => true);

      // Act
      final result = await repository.loginUser(userId);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), true);
    });

    test('should return false if user does not exist', () async {
      // Arrange
      when(() => mockRemoteDataSource.loginUser(userId)).thenAnswer((_) async => false);

      // Act
      final result = await repository.loginUser(userId);

      // Assert
      expect(result.isRight(), true);
      expect(result.getOrElse(() => false), false);
    });
  });
}
