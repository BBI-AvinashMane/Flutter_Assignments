import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';


abstract class AuthenticateRepository {
  Future<Either<Failure, String>> registerUser();
  Future<Either<Failure, bool>> loginUser(String userId);
  Future<Either<Failure, void>> logoutUser(); 
}


// import 'package:task_manager_firebase/core/shared/firebase_service.dart';

// class AuthRepository {
//   final FirebaseService firebaseService;

//   AuthRepository(this.firebaseService);

//   Future<String> createUser() async {
//     return await firebaseService.createUser();
//   }
// }
