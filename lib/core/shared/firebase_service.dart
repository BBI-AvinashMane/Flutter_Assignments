
// import 'package:firebase_database/firebase_database.dart';

// class FirebaseService {
//   final FirebaseDatabase _database = FirebaseDatabase.instance;

//   /// Creates a new user and returns the user ID.
//   Future<String> createUser() async {
//     try {
//       String userId = _database.ref().push().key!;
//       await _database.ref('users/$userId').set({
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       return userId;
//     } catch (e) {
//       throw Exception("Failed to create user: $e");
//     }
//   }

//   /// Adds a task for a specific user.
//   Future<void> addTask(String userId, Map<String, dynamic> taskData) async {
//     try {
//       await _database.ref('users/$userId/tasks').push().set(taskData);
//     } catch (e) {
//       throw Exception("Failed to add task: $e");
//     }
//   }

//   /// Updates an existing task for a specific user.
//   Future<void> updateTask(String userId, String taskId, Map<String, dynamic> updatedData) async {
//     try {
//       await _database.ref('users/$userId/tasks/$taskId').update(updatedData);
//     } catch (e) {
//       throw Exception("Failed to update task: $e");
//     }
//   }

//   /// Deletes a task for a specific user.
//   Future<void> deleteTask(String userId, String taskId) async {
//     try {
//       await _database.ref('users/$userId/tasks/$taskId').remove();
//     } catch (e) {
//       throw Exception("Failed to delete task: $e");
//     }
//   }

//   /// Fetches tasks for a specific user as a stream of DatabaseEvents.
//   Stream<DatabaseEvent> fetchTasks(String userId) {
//     try {
//       return _database.ref('users/$userId/tasks').onValue;
//     } catch (e) {
//       throw Exception("Failed to fetch tasks: $e");
//     }
//   }
// }
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Creates a new user with an incrementing ID like user_1, user_2, etc.
  Future<String> createUser() async {
    try {
      // Atomically increment user_count and retrieve the new count
      final transactionResult = await _database.ref("user_count").runTransaction((currentValue) {
        if (currentValue == null) {
          return Transaction.success(1); // Initialize the count to 1 if not present
        }
        if (currentValue is int) {
          return Transaction.success(currentValue + 1); // Increment the count
        }
        return Transaction.abort(); // Abort the transaction for invalid value types
      });

      if (transactionResult.committed && transactionResult.snapshot.value != null) {
        final userId = "user_${transactionResult.snapshot.value}";

        // Create the user record in the database
        await _database.ref("users/$userId").set({
          "userId": userId,
          "registeredAt": DateTime.now().toIso8601String(),
        });

        return userId; // Return the generated user ID
      } else {
        throw Exception("Failed to increment user count");
      }
    } catch (e) {
      throw Exception("Failed to create user: $e");
    }
  }

  /// Adds a task for the specified user
  Future<void> addTask(String userId, Map<String, dynamic> taskData) async {
    try {
      await _database.ref("users/$userId/tasks").push().set(taskData);
    } catch (e) {
      throw Exception("Failed to add task: $e");
    }
  }

  /// Updates an existing task for the specified user
  Future<void> updateTask(String userId, String taskId, Map<String, dynamic> updatedData) async {
    try {
      await _database.ref("users/$userId/tasks/$taskId").update(updatedData);
    } catch (e) {
      throw Exception("Failed to update task: $e");
    }
  }

  /// Deletes a task for the specified user
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _database.ref("users/$userId/tasks/$taskId").remove();
    } catch (e) {
      throw Exception("Failed to delete task: $e");
    }
  }

  /// Fetches tasks for the specified user as a stream
  Stream<DatabaseEvent> fetchTasks(String userId) {
    try {
      return _database.ref("users/$userId/tasks").onValue;
    } catch (e) {
      throw Exception("Failed to fetch tasks: $e");
    }
  }
}
