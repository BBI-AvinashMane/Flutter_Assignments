import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/login_user.dart';
import 'package:task_manager_firebase/features/authenticate/domain/repositories/authenticate_repository.dart';

class MockAuthenticateRepository extends Mock implements AuthenticateRepository {}

void main() {
  late LoginUser useCase;
  late MockAuthenticateRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticateRepository();
    useCase = LoginUser(mockRepository);
  });

  const tUserId = 'user_1';

  group('LoginUser Use Case', () {
    test('should return true when the user exists', () async {
      // Arrange
      when(() => mockRepository.loginUser(tUserId))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase(tUserId);

      // Assert
      verify(() => mockRepository.loginUser(tUserId)).called(1);
      expect(result, const Right(true));
    });

    test('should return false when the user does not exist', () async {
      // Arrange
      when(() => mockRepository.loginUser(tUserId))
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await useCase(tUserId);

      // Assert
      verify(() => mockRepository.loginUser(tUserId)).called(1);
      expect(result, const Right(false));
    });

    test('should return ServerFailure when the repository call fails', () async {
      // Arrange
      const tFailureMessage = 'Failed to login user';
      when(() => mockRepository.loginUser(tUserId))
          .thenAnswer((_) async => Left(ServerFailure(tFailureMessage)));

      // Act
      final result = await useCase(tUserId);

      // Assert
      verify(() => mockRepository.loginUser(tUserId)).called(1);
      expect(result, Left(ServerFailure(tFailureMessage)));
    });
  });
}
