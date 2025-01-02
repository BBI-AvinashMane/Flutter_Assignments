import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
import 'package:task_manager_firebase/features/manage_task/domain/repositories/task_repository.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/add_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late AddTask usecase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    usecase = AddTask(mockTaskRepository);
  });

  group('AddTask UseCase', () {
    const String userId = 'user_1';
    final TaskEntity task = TaskEntity(
      id: 'task_1',
      title: 'Test Task',
      description: 'Test Description',
      dueDate: DateTime.now(),
      priority: 'High',
      userId: 'user_1',
    );

    test('should call addTask on the repository and return Right(void) when successful', () async {
      // Arrange
      when(() => mockTaskRepository.addTask(task, userId))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(AddTaskParams(task, userId));

      // Assert
      expect(result, const Right(null));
      verify(() => mockTaskRepository.addTask(task, userId)).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });

    test('should return Left(Failure) when the repository returns a failure', () async {
      // Arrange
      const failure = ServerFailure('Server Error');
      when(() => mockTaskRepository.addTask(task, userId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(AddTaskParams(task, userId));

      // Assert
      expect(result, const Left(failure));
      verify(() => mockTaskRepository.addTask(task, userId)).called(1);
      verifyNoMoreInteractions(mockTaskRepository);
    });
  });
}
