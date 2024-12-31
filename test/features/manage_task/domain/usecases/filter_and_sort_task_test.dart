import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/get_task.dart';
import 'package:task_manager_firebase/features/manage_task/domain/repositories/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late GetTasks useCase;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = GetTasks(mockRepository);
  });

  const userId = 'user_1';
  final taskList = [
    TaskEntity(id: 'task_1', title: 'Task 1', description: 'Description', priority: 'High', dueDate: DateTime(2024, 12, 31), userId: userId),
    TaskEntity(id: 'task_2', title: 'Task 2', description: 'Description', priority: 'Low', dueDate: DateTime(2024, 11, 30), userId: userId),
  ];

  test('should return a list of tasks from the repository', () async {
    // Arrange
    when(() => mockRepository.fetchTasks(userId)).thenAnswer((_) async => Right(taskList));

    // Act
    final result = await useCase(userId);

    // Assert
    expect(result, Right(taskList));
    verify(() => mockRepository.fetchTasks(userId)).called(1);
  });

  test('should return a failure when repository fails', () async {
    // Arrange
    when(() => mockRepository.fetchTasks(userId)).thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await useCase(userId);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(() => mockRepository.fetchTasks(userId)).called(1);
  });
}
