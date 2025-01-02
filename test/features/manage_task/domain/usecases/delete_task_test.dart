import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/manage_task/domain/repositories/task_repository.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/delete_task.dart';


class MockTaskRepository extends Mock implements TaskRepository {}
void main() {
  late MockTaskRepository mockTaskRepository;
  late DeleteTask deleteTaskUseCase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    deleteTaskUseCase = DeleteTask(mockTaskRepository);
  });

  group('DeleteTask', () {
    const taskId = 'task_1';
    const userId = 'user_1';

    test('should call deleteTask on the repository and return Right(void) when successful', () async {
      // Arrange
      when(() => mockTaskRepository.deleteTask(taskId, userId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await deleteTaskUseCase(DeleteTaskParams(taskId, userId));

      // Assert
      expect(result, const Right(null));
      verify(() => mockTaskRepository.deleteTask(taskId, userId)).called(1);
    });

    test('should return Left(Failure) when the repository returns a failure', () async {
      // Arrange
      final failure = ServerFailure('Server Error');
      when(() => mockTaskRepository.deleteTask(taskId, userId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await deleteTaskUseCase(DeleteTaskParams(taskId, userId));

      // Assert
      expect(result, Left(failure));
      verify(() => mockTaskRepository.deleteTask(taskId, userId)).called(1);
    });
  });
}
