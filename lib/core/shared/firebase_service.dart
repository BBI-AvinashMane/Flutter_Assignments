import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<String> createUser() async {
    String userId = _database.ref().push().key!;
    await _database.ref('users/$userId').set({'created_at': DateTime.now().toIso8601String()});
    return userId;
  }

  Future<void> addTask(String userId, Map<String, dynamic> taskData) async {
    await _database.ref('users/$userId/tasks').push().set(taskData);
  }

  Future<void> updateTask(String userId, String taskId, Map<String, dynamic> updatedData) async {
    await _database.ref('users/$userId/tasks/$taskId').update(updatedData);
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _database.ref('users/$userId/tasks/$taskId').remove();
  }

  Stream<DatabaseEvent> fetchTasks(String userId) {
    return _database.ref('users/$userId/tasks').onValue;
  }
}
