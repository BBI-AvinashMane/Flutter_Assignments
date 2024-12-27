// import 'package:dartz/dartz.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:task_manager_firebase/core/error/failures.dart';
// import 'package:task_manager_firebase/features/manage_task/data/models/task_model.dart';
// import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
// import 'package:task_manager_firebase/features/manage_task/domain/repositories/task_repository.dart';


// class TaskRepositoryImpl implements TaskRepository {
//   final FirebaseDatabase firebaseDatabase;

//   TaskRepositoryImpl(this.firebaseDatabase);

//   @override
//   Future<Either<Failure, void>> addTask(TaskEntity task) async {
//     try {
//       final taskRef = firebaseDatabase.ref('tasks').push();
//       await taskRef.set(TaskModel.fromEntity(task).toJson());
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure("Failed to add task: ${e.toString()}"));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteTask(String taskId) async {
//     try {
//       await firebaseDatabase.ref('tasks/$taskId').remove();
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure("Failed to delete task: ${e.toString()}"));
//     }
//   }

//   @override
//   Future<Either<Failure, List<TaskEntity>>> fetchTasks(String userId) async {
//     try {
//       final snapshot = await firebaseDatabase.ref('tasks').orderByChild('userId').equalTo(userId).get();
//       if (snapshot.exists) {
//         final tasks = snapshot.children.map((child) {
//           return TaskModel.fromJson(Map<String, dynamic>.from(child.value as Map))
//               .toEntity(child.key!);
//         }).toList();
//         return Right(tasks);
//       } else {
//         return Right([]);
//       }
//     } catch (e) {
//       return Left(ServerFailure("Failed to fetch tasks: ${e.toString()}"));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updateTask(TaskEntity task) async {
//     try {
//       await firebaseDatabase.ref('tasks/${task.id}').update(TaskModel.fromEntity(task).toJson());
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure("Failed to update task: ${e.toString()}"));
//     }
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import 'package:task_manager_firebase/features/manage_task/data/models/task_model.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
import 'package:task_manager_firebase/features/manage_task/domain/repositories/task_repository.dart';


class TaskRepositoryImpl implements TaskRepository {
  final FirebaseDatabase firebaseDatabase;

  TaskRepositoryImpl(this.firebaseDatabase);

 @override
Future<Either<Failure, void>> addTask(TaskEntity task, String userId) async {
  try {
    final taskRef = firebaseDatabase.ref('tasks/$userId').push();
    await taskRef.set(TaskModel.fromEntity(task).toJson());
    return const Right(null);
  } catch (e) {
    return Left(ServerFailure("Failed to add task: ${e.toString()}"));
  }
}


 @override
Future<Either<Failure, void>> deleteTask(String taskId, String userId) async {
  try {
    await firebaseDatabase.ref('tasks/$userId/$taskId').remove();
    return const Right(null);
  } catch (e) {
    return Left(ServerFailure("Failed to delete task: ${e.toString()}"));
  }
}

  @override
  Future<Either<Failure, List<TaskEntity>>> fetchTasks(String userId) async {
    try {
      final snapshot = await firebaseDatabase.ref('tasks').orderByChild('userId').equalTo(userId).get();
      if (snapshot.exists) {
        final tasks = snapshot.children.map((child) {
          return TaskModel.fromJson(Map<String, dynamic>.from(child.value as Map))
              .toEntity(child.key!);
        }).toList();
        return Right(tasks);
      } else {
        return Right([]);
      }
    } catch (e) {
      return Left(ServerFailure("Failed to fetch tasks"));
    }
  }

  @override
Future<Either<Failure, void>> updateTask(TaskEntity task, String userId) async {
  try {
    await firebaseDatabase.ref('tasks/$userId/${task.id}').update(TaskModel.fromEntity(task).toJson());
    return const Right(null);
  } catch (e) {
    return Left(ServerFailure("Failed to update task: ${e.toString()}"));
  }
}

}
