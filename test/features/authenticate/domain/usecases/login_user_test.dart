import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/features/authenticate/domain/entities/authenticate_entity.dart';
import 'package:task_manager_firebase/features/authenticate/domain/repositories/authenticate_repository.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/login_user.dart';
import 'package:task_manager_firebase/core/error/failures.dart';

class MockAuthenticateRepository extends Mock
    implements AuthenticateRepository {}

void main() {
  late MockAuthenticateRepository mockAuthenticateRepository;
  late LoginUser useCase;

  setUp(() {
    mockAuthenticateRepository = MockAuthenticateRepository();
    useCase = LoginUser(repository: mockAuthenticateRepository);
  });

  const userId = 'user_1';
  final user = AuthenticateEntity(userId: userId);

  test('should return user when login is successful', () async {
    // Arrange
    when(() => mockAuthenticateRepository.loginUser(userId))
        .thenAnswer((_) async => Right(user));

    // Act
    final result = await useCase(userId);

    // Assert
    verify(() => mockAuthenticateRepository.loginUser(userId)).called(1);
    expect(result, Right(user));
  });

  test('should return failure when login fails', () async {
    // Arrange
    when(() => mockAuthenticateRepository.loginUser(userId))
        .thenAnswer((_) async => const Left(ServerFailure()));

    // Act
    final result = await useCase(userId);

    // Assert
    verify(() => mockAuthenticateRepository.loginUser(userId)).called(1);
    expect(result, const Left(ServerFailure()));
  });
}
