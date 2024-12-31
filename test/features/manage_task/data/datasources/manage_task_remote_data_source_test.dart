import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_firebase/features/manage_task/data/datasources/manage_task_remote_data_source.dart';
import 'package:task_manager_firebase/features/manage_task/data/models/task_model.dart';
import 'package:firebase_database/firebase_database.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

void main() {
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockDatabaseReference;
  late ManageTaskRemoteDataSourceImpl dataSource;

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    dataSource = ManageTaskRemoteDataSourceImpl(mockFirebaseDatabase);

    // Mock FirebaseDatabase ref to return a valid MockDatabaseReference
    when(() => mockFirebaseDatabase.ref()).thenReturn(mockDatabaseReference);

    // Mock DatabaseReference child to return itself
    when(() => mockDatabaseReference.child(any())).thenReturn(mockDatabaseReference);

    // Mock set method on DatabaseReference
    when(() => mockDatabaseReference.set(any())).thenAnswer((_) async {});
  });

  group('addTask', () {
    const userId = 'user_1';
    final taskModel = TaskModel(
      id: 'task_1',
      title: 'New Task',
      description: 'Description',
      priority: 'High',
      dueDate: DateTime.parse('2024-12-31'),
      userId: userId,
    );

    test('should add task to Firebase', () async {
      // Act
      await dataSource.addTask(taskModel,userId);

      // Assert
      verify(() => mockDatabaseReference.child('tasks/${taskModel.id}')).called(1);
      verify(() => mockDatabaseReference.set(taskModel.toJson())).called(1);
    });
  });
}
