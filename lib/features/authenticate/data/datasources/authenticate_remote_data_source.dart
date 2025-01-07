// import 'package:firebase_database/firebase_database.dart';

// abstract class AuthenticateRemoteDataSource {
//   /// Registers a new user and returns the generated user ID.
//   Future<String> registerUser();

//   /// Checks if a user exists in the database.
//   Future<bool> loginUser(String userId);
// }


// class AuthenticateRemoteDataSourceImpl implements AuthenticateRemoteDataSource {
//   final FirebaseDatabase database;

//   AuthenticateRemoteDataSourceImpl(this.database);

//   @override
//   Future<String> registerUser() async {
//     final transactionResult = await database.ref("user_count").runTransaction((currentValue) {
//       if (currentValue == null) {
//         return Transaction.success(1);
//       }
//       if (currentValue is int) {
//         return Transaction.success(currentValue + 1);
//       }
//       return Transaction.abort();
//     });

//     if (transactionResult.committed && transactionResult.snapshot.value != null) {
//       final userId = "user_${transactionResult.snapshot.value}";
//       await database.ref("users/$userId").set({
//         "userId": userId,
//         "registeredAt": DateTime.now().toIso8601String(),
//       });
//       return userId;
//     } else {
//       throw Exception("Failed to register user");
//     }
//   }

//   @override
//   Future<bool> loginUser(String userId) async {
//     final snapshot = await database.ref("users/$userId").get();
//     return snapshot.exists;
//   }
// }
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';

abstract class AuthenticateRemoteDataSource {
  /// Registers a new user and returns the generated user ID.
  Future<String> registerUser();

  /// Checks if a user exists in the database.
  Future<bool> loginUser(String userId);
}


class AuthenticateRemoteDataSourceImpl implements AuthenticateRemoteDataSource {
  final FirebaseDatabase database;

  AuthenticateRemoteDataSourceImpl(this.database);

  @override
  Future<String> registerUser() async {
    final transactionResult = await database.ref(Constants.userCount).runTransaction((currentValue) {
      if (currentValue == null) {
        return Transaction.success(1);
      }
      if (currentValue is int) {
        return Transaction.success(currentValue + 1);
      }
      return Transaction.abort();
    });

    if (transactionResult.committed && transactionResult.snapshot.value != null) {
      final userId = "${Constants.userIdPrefix}${transactionResult.snapshot.value}";
      await database.ref("${Constants.usersPath}${userId}").set({
        Constants.userId: userId,
        Constants.registeredAt: DateTime.now().toIso8601String(),
      });
      return userId;
    } else {
      throw Exception(Constants.failedToRegisterUser);
    }
  }

  @override
  Future<bool> loginUser(String userId) async {
    final snapshot = await database.ref("${Constants.usersPath}${userId}").get();
    return snapshot.exists;
  }
}