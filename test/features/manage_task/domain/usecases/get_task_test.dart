import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
import 'package:task_manager_firebase/features/manage_task/domain/repositories/task_repository.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/get_task.dart';


class MockTaskRepository extends Mock implements TaskRepository {}
void main() {
  late MockTaskRepository mockTaskRepository;
  late GetTasks getTasksUseCase;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getTasksUseCase = GetTasks(mockTaskRepository);
  });

  group('GetTasks', () {
    const userId = 'user_1';
    final tasks = [
      TaskEntity(id: '1', title: 'Task A', description: '', dueDate: DateTime.now(), priority: 'High',userId: 'userId'),
    ];

    test('should call fetchTasks on the repository and return a list of tasks when successful', () async {
      // Arrange
      when(() => mockTaskRepository.fetchTasks(userId))
          .thenAnswer((_) async => Right(tasks));

      // Act
      final result = await getTasksUseCase(userId);

      // Assert
      expect(result, Right(tasks));
      verify(() => mockTaskRepository.fetchTasks(userId)).called(1);
    });

    test('should return Left(Failure) when the repository returns a failure', () async {
      // Arrange
      final failure = ServerFailure('Server Error');
      when(() => mockTaskRepository.fetchTasks(userId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getTasksUseCase(userId);

      // Assert
      expect(result, Left(failure));
      verify(() => mockTaskRepository.fetchTasks(userId)).called(1);
    });
  });
}
