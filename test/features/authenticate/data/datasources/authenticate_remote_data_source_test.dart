import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_firebase/features/authenticate/data/datasources/authenticate_remote_data_source.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockTransactionResult extends Mock implements TransactionResult {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockDatabaseReference mockDatabaseReference;
  late AuthenticateRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockDatabaseReference = MockDatabaseReference();
    remoteDataSource = AuthenticateRemoteDataSourceImpl(mockFirebaseDatabase);

    // Mock FirebaseDatabase.ref() to return a mock DatabaseReference
    when(() => mockFirebaseDatabase.ref()).thenReturn(mockDatabaseReference);

    // Mock DatabaseReference.child() to return itself for chaining
    when(() => mockDatabaseReference.child(any())).thenReturn(mockDatabaseReference);
  });

  group('registerUser', () {
    test('should increment user count and register new user', () async {
      // Arrange
      final mockTransactionResult = MockTransactionResult();
      when(() => mockTransactionResult.committed).thenReturn(true);
      when(() => mockTransactionResult.snapshot.value).thenReturn(1);

      when(() => mockDatabaseReference.runTransaction(any()))
          .thenAnswer((invocation) async {
        final transactionHandler = invocation.positionalArguments[0] as TransactionHandler;
        transactionHandler(null); // Simulate a transaction handler call
        return mockTransactionResult;
      });

      when(() => mockDatabaseReference.set(any())).thenAnswer((_) async {});

      // Act
      final result = await remoteDataSource.registerUser();

      // Assert
      expect(result, equals('user_1'));
      verify(() => mockDatabaseReference.child('user_count')).called(1);
      verify(() => mockDatabaseReference.child('users/user_1')).called(1);
    });

    test('should throw exception if transaction fails', () async {
      // Arrange
      final mockTransactionResult = MockTransactionResult();
      when(() => mockTransactionResult.committed).thenReturn(false);

      when(() => mockDatabaseReference.runTransaction(any()))
          .thenAnswer((_) async => mockTransactionResult);

      // Act & Assert
      expect(
        () => remoteDataSource.registerUser(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('loginUser', () {
    const userId = 'user_1';

    test('should return true if user exists in Firebase', () async {
      // Arrange
      final mockDataSnapshot = MockDataSnapshot();
      when(() => mockDatabaseReference.get())
          .thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(true);

      // Act
      final result = await remoteDataSource.loginUser(userId);

      // Assert
      expect(result, isTrue);
      verify(() => mockDatabaseReference.child('users/$userId')).called(1);
    });

    test('should return false if user does not exist', () async {
      // Arrange
      final mockDataSnapshot = MockDataSnapshot();
      when(() => mockDatabaseReference.get())
          .thenAnswer((_) async => mockDataSnapshot);
      when(() => mockDataSnapshot.exists).thenReturn(false);

      // Act
      final result = await remoteDataSource.loginUser(userId);

      // Assert
      expect(result, isFalse);
      verify(() => mockDatabaseReference.child('users/$userId')).called(1);
    });
  });
}
