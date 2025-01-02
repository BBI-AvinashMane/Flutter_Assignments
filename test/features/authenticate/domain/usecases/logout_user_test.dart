import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import 'package:task_manager_firebase/features/authenticate/domain/repositories/authenticate_repository.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/logout_user.dart';

class MockAuthenticateRepository extends Mock
    implements AuthenticateRepository {}

void main() {
  late MockAuthenticateRepository mockAuthenticateRepository;
  late LogoutUser useCase;

  setUp(() {
    mockAuthenticateRepository = MockAuthenticateRepository();
    useCase = LogoutUser(mockAuthenticateRepository);
  });

  group('LogoutUser Use Case', () {
    test('should return success when logout is successful', () async {
      // Arrange
      when(() => mockAuthenticateRepository.logoutUser())
          .thenAnswer((_) async => const Right(null)); // Return a successful result

      // Act
      final result = await useCase(NoParams());

      // Assert
      verify(() => mockAuthenticateRepository.logoutUser()).called(1);
      expect(result, const Right(null)); // Expecting a successful response
    });

    test('should return failure when logout fails', () async {
      // Arrange
      const failure = ServerFailure('Logout failed');
      when(() => mockAuthenticateRepository.logoutUser())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      verify(() => mockAuthenticateRepository.logoutUser()).called(1);
      expect(result, const Left(failure));
    });
  });
}
