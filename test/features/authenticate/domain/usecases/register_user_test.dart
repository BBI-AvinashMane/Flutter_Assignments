import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/features/authenticate/domain/entities/authenticate_entity.dart';
import 'package:task_manager_firebase/features/authenticate/domain/repositories/authenticate_repository.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/register_user.dart';
import 'package:task_manager_firebase/core/error/failures.dart';

class MockAuthenticateRepository extends Mock
    implements AuthenticateRepository {}

void main() {
  late MockAuthenticateRepository mockAuthenticateRepository;
  late RegisterUser useCase;

  setUp(() {
    mockAuthenticateRepository = MockAuthenticateRepository();
    useCase = RegisterUser(repository: mockAuthenticateRepository);
  });

  const userId = 'user_1';
  final user = AuthenticateEntity(userId: userId);

  test('should return success when user registration is successful', () async {
    // Arrange
    when(() => mockAuthenticateRepository.registerUser(user))
        .thenAnswer((_) async => const Right(unit));

    // Act
    final result = await useCase(user);

    // Assert
    verify(() => mockAuthenticateRepository.registerUser(user)).called(1);
    expect(result, const Right(unit));
  });

  test('should return failure when user registration fails', () async {
    // Arrange
    when(() => mockAuthenticateRepository.registerUser(user))
        .thenAnswer((_) async => const Left(ServerFailure()));

    // Act
    final result = await useCase(user);

    // Assert
    verify(() => mockAuthenticateRepository.registerUser(user)).called(1);
    expect(result, const Left(ServerFailure()));
  });
}
