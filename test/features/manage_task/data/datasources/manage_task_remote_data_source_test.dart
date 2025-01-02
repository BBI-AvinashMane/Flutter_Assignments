import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_firebase/features/manage_task/data/datasources/manage_task_remote_data_source.dart';
import 'package:task_manager_firebase/features/manage_task/data/models/task_model.dart';


// Mock classes
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}
class MockDatabaseReference extends Mock implements DatabaseReference {}
class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late ManageTaskRemoteDataSourceImpl dataSource;
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockDatabaseReference;
  late MockDataSnapshot mockDataSnapshot;

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    mockDataSnapshot = MockDataSnapshot();
    dataSource = ManageTaskRemoteDataSourceImpl(mockFirebaseDatabase);
  });

  group('addTask', () {
    test('should push and set the task to Firebase Database', () async {
      // Arrange
      final task = TaskModel(
        id: 'task_1',
        title: 'Test Task',
        description: 'Description',
        dueDate: DateTime.now(),
        priority: 'High',userId: 'user_1',
      );
      final userId = 'user_1';
      when(() => mockFirebaseDatabase.ref(any())).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.push()).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.set(any())).thenAnswer((_) async => Future.value());

      // Act
      await dataSource.addTask(task, userId);

      // Assert
      verify(() => mockDatabaseReference.set(task.toJson())).called(1);
    });
  });

  group('updateTask', () {
    test('should update the task in Firebase Database', () async {
      // Arrange
      final task = TaskModel(
        id: 'task_1',
        title: 'Updated Task',
        description: 'Updated Description',
        dueDate: DateTime.now(),
        priority: 'Medium',userId: 'user_1',
      );
      final userId = 'user_1';
      when(() => mockFirebaseDatabase.ref(any())).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.update(any())).thenAnswer((_) async => Future.value());

      // Act
      await dataSource.updateTask(task, userId);

      // Assert
      verify(() => mockDatabaseReference.update(task.toJson())).called(1);
    });
  });

  group('deleteTask', () {
    test('should remove the task from Firebase Database', () async {
      // Arrange
      final taskId = 'task_1';
      final userId = 'user_1';
      when(() => mockFirebaseDatabase.ref(any())).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.remove()).thenAnswer((_) async => Future.value());

      // Act
      await dataSource.deleteTask(taskId, userId);

      // Assert
      verify(() => mockDatabaseReference.remove()).called(1);
    });
  });

    group('fetchTasks', () {
    test('should fetch tasks from Firebase Database and return a list of TaskModel', () async {
      // Arrange
      final userId = 'user_1';
      final taskMap = {
        'title': 'Test Task',
        'description': 'Test Description',
        'dueDate': DateTime.now().toIso8601String(),
        'priority': 'Low',
        'userId':'user_1',
      };
      final childSnapshot = MockDataSnapshot();

      when(() => mockFirebaseDatabase.ref(any())).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(true);
      when(() => mockDataSnapshot.children).thenReturn([childSnapshot]);
      when(() => childSnapshot.key).thenReturn('task_1');
      when(() => childSnapshot.value).thenReturn(taskMap);

      // Act
      final tasks = await dataSource.fetchTasks(userId);

      // Assert
      expect(tasks, isA<List<TaskModel>>());
      expect(tasks.length, 1);
      expect(tasks[0].title, 'Test Task');
    });

    test('should return an empty list if no tasks exist', () async {
      // Arrange
      final userId = 'user_1';
      when(() => mockFirebaseDatabase.ref(any())).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(false);

      // Act
      final tasks = await dataSource.fetchTasks(userId);

      // Assert
      expect(tasks, isEmpty);
    });
  

    test('should return an empty list if no tasks exist', () async {
      // Arrange
      final userId = 'user_1';
      when(() => mockFirebaseDatabase.ref(any())).thenReturn(mockDatabaseReference);
      when(() => mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(false);

      // Act
      final tasks = await dataSource.fetchTasks(userId);

      // Assert
      expect(tasks, isEmpty);
    });
  });
}
