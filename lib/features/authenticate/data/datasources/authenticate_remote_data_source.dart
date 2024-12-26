import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_firebase/core/error/exceptions.dart';


abstract class AuthenticateRemoteDataSource {
  Future<String> registerUser();
  Future<bool> loginUser(String userId);
}

// class AuthenticateRemoteDataSourceImpl implements AuthenticateRemoteDataSource {
//   final FirebaseDatabase database;

//   AuthenticateRemoteDataSourceImpl(this.database);

//   @override
//   Future<String> registerUser() async {
//     try {
//       final userId = database.ref().push().key!;
//       await database.ref('users/$userId').set({
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       return userId;
//     } catch (e) {
//       throw ServerException();
//     }
//   }

//   @override
//   Future<bool> loginUser(String userId) async {
//     final userSnapshot = await database.ref('users/$userId').get();
//     return userSnapshot.exists;
//   }
// }
class AuthenticateRemoteDataSourceImpl implements AuthenticateRemoteDataSource {
  final FirebaseDatabase database;

  AuthenticateRemoteDataSourceImpl(this.database);

  @override
  Future<String> registerUser() async {
    try {
      print("Attempting to generate user ID...");
      final userId = database.ref().push().key!;
      print("Generated user ID: $userId");

      print("Writing user ID to Firebase...");
      await database.ref('users/$userId').set({
        'created_at': DateTime.now().toIso8601String(),
      });
      print("User ID written successfully!");
      return userId;
    } catch (e) {
      print("Registration failed: $e");
      throw ServerException();
    }
  }
   @override
  Future<bool> loginUser(String userId) async {
    final userSnapshot = await database.ref('users/$userId').get();
    return userSnapshot.exists;
  }
}
