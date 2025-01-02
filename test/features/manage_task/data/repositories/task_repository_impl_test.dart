import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_firebase/features/manage_task/data/datasources/manage_task_remote_data_source.dart';
import 'package:task_manager_firebase/features/manage_task/data/models/task_model.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockDatabaseReference;
  late ManageTaskRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    remoteDataSource = ManageTaskRemoteDataSourceImpl(mockFirebaseDatabase);

    // Mock FirebaseDatabase.ref to return a valid MockDatabaseReference
    when(() => mockFirebaseDatabase.ref(any()))
        .thenReturn(mockDatabaseReference);

    // Mock DatabaseReference.child to return itself
    when(() => mockDatabaseReference.child(any()))
        .thenReturn(mockDatabaseReference);
  });

  group('addTask', () {
    const userId = 'user_1';
    final taskModel = TaskModel(
      id: 'task_1',
      title: 'Test Task',
      description: 'Test Description',
      priority: 'High',
      dueDate: DateTime(2024, 12, 31),
      userId: 'user_1',
    );

    test('should add a task for the specified user', () async {
      // Arrange
      when(() => mockDatabaseReference.push()).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.set(taskModel.toJson()))
          .thenAnswer((_) async {});

      // Act
      await remoteDataSource.addTask(taskModel, userId);

      // Assert
      verify(() => mockFirebaseDatabase.ref('users/$userId/tasks')).called(1);
      verify(() => mockDatabaseReference.push()).called(1);
      verify(() => mockDatabaseReference.set(taskModel.toJson())).called(1);
    });
  });

  group('updateTask', () {
    const userId = 'user_1';
    final taskModel = TaskModel(
      id: 'task_1',
      title: 'Updated Task',
      description: 'Updated Description',
      priority: 'Medium',
      dueDate: DateTime(2024, 12, 31),
      userId: 'user_1',
    );

    test('should update an existing task for the specified user', () async {
      // Arrange
      when(() => mockDatabaseReference.update(taskModel.toJson()))
          .thenAnswer((_) async {});

      // Act
      await remoteDataSource.updateTask(taskModel, userId);

      // Assert
      verify(() => mockFirebaseDatabase
          .ref('users/$userId/tasks/${taskModel.id}')).called(1);
      verify(() => mockDatabaseReference.update(taskModel.toJson())).called(1);
    });
  });

  group('deleteTask', () {
    const userId = 'user_1';
    const taskId = 'task_1';

    test('should delete a task for the specified user', () async {
      // Arrange
      when(() => mockDatabaseReference.remove()).thenAnswer((_) async {});

      // Act
      await remoteDataSource.deleteTask(taskId, userId);

      // Assert
      verify(() => mockFirebaseDatabase.ref('users/$userId/tasks/$taskId'))
          .called(1);
      verify(() => mockDatabaseReference.remove()).called(1);
    });
  });

  group('fetchTasks', () {
    const userId = 'user_1';

    test('should fetch a list of tasks for the specified user', () async {
      // Arrange
      final mockDataSnapshot = MockDataSnapshot();
      final mockChildSnapshot = MockDataSnapshot();
      final taskJson = {
        'title': 'Test Task',
        'description': 'Test Description',
        'priority': 'High',
        'dueDate': '2024-12-31T00:00:00.000',
        'userId':  'user_1',
      };

      when(() => mockDatabaseReference.get())
          .thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(true);
      when(() => mockDataSnapshot.children).thenReturn([mockChildSnapshot]);
      when(() => mockChildSnapshot.key).thenReturn('task_1');
      when(() => mockChildSnapshot.value).thenReturn(taskJson);

      // Act
      final result = await remoteDataSource.fetchTasks(userId);

      // Assert
      expect(result, isA<List<TaskModel>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Task');
      verify(() => mockFirebaseDatabase.ref('users/$userId/tasks')).called(1);
      verify(() => mockDatabaseReference.get()).called(1);
    });

    test('should return an empty list if no tasks exist', () async {
      // Arrange
      final mockDataSnapshot = MockDataSnapshot();
      when(() => mockDatabaseReference.get())
          .thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(false);

      // Act
      final result = await remoteDataSource.fetchTasks(userId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockFirebaseDatabase.ref('users/$userId/tasks')).called(1);
      verify(() => mockDatabaseReference.get()).called(1);
    });
  });
}
