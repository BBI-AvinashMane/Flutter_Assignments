import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
import 'package:task_manager_firebase/features/manage_task/domain/repositories/task_repository.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/update_task.dart';


class MockTaskRepository extends Mock implements TaskRepository {}
void main() {
  late MockTaskRepository mockTaskRepository;
  late UpdateTask updateTaskUseCase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    updateTaskUseCase = UpdateTask(mockTaskRepository);
  });

  group('UpdateTask', () {
    const userId = 'user_1';
    final task = TaskEntity(
      id: '1',
      title: 'Updated Task',
      description: 'Updated Description',
      dueDate: DateTime.now(),
      priority: 'Medium',
      userId:'user_1',
    );

    test('should call updateTask on the repository and return Right(void) when successful', () async {
      // Arrange
      when(() => mockTaskRepository.updateTask(task, userId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await updateTaskUseCase(UpdateTaskParams(task, userId));

      // Assert
      expect(result, const Right(null));
      verify(() => mockTaskRepository.updateTask(task, userId)).called(1);
    });

    test('should return Left(Failure) when the repository returns a failure', () async {
      // Arrange
      final failure = ServerFailure('Server Error');
      when(() => mockTaskRepository.updateTask(task, userId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await updateTaskUseCase(UpdateTaskParams(task, userId));

      // Assert
      expect(result, Left(failure));
      verify(() => mockTaskRepository.updateTask(task, userId)).called(1);
    });
  });
}
