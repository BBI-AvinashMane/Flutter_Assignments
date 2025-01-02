import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import 'package:task_manager_firebase/features/authenticate/domain/repositories/authenticate_repository.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/register_user.dart';

class MockAuthenticateRepository extends Mock
    implements AuthenticateRepository {}

void main() {
  late MockAuthenticateRepository mockAuthenticateRepository;
  late RegisterUser useCase;

  setUp(() {
    mockAuthenticateRepository = MockAuthenticateRepository();
    useCase = RegisterUser(mockAuthenticateRepository);
  });

  group('RegisterUser Use Case', () {
    test('should return user ID when registration is successful', () async {
      // Arrange
      const userId = 'user_1';
      when(() => mockAuthenticateRepository.registerUser())
          .thenAnswer((_) async => const Right(userId));

      // Act
      final result = await useCase(NoParams());

      // Assert
      verify(() => mockAuthenticateRepository.registerUser()).called(1);
      expect(result, const Right(userId)); // Expecting a successful user ID
    });

    test('should return failure when registration fails', () async {
      // Arrange
      const failure = ServerFailure('Registration failed');
      when(() => mockAuthenticateRepository.registerUser())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      verify(() => mockAuthenticateRepository.registerUser()).called(1);
      expect(result, const Left(failure)); // Expecting a failure
    });
  });
}
