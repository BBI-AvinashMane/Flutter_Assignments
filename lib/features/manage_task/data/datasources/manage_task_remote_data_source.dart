import 'package:firebase_database/firebase_database.dart';
import '../models/task_model.dart';


abstract class ManageTaskRemoteDataSource {
  Future<void> addTask(TaskModel task, String userId); // TaskModel used
  Future<void> updateTask(TaskModel task, String userId); // TaskModel used
  Future<void> deleteTask(String taskId, String userId);
  Future<List<TaskModel>> fetchTasks(String userId); // TaskModel used
}


class ManageTaskRemoteDataSourceImpl implements ManageTaskRemoteDataSource {
  final FirebaseDatabase firebaseDatabase;

  ManageTaskRemoteDataSourceImpl(this.firebaseDatabase);

  @override
  Future<void> addTask(TaskModel task, String userId) async {
    final taskRef = firebaseDatabase.ref('users/$userId/tasks').push();
    await taskRef.set(task.toJson());
  }

  @override
  Future<void> updateTask(TaskModel task, String userId) async {
    await firebaseDatabase
        .ref('users/$userId/tasks/${task.id}')
        .update(task.toJson());
  }

  @override
  Future<void> deleteTask(String taskId, String userId) async {
    await firebaseDatabase.ref('users/$userId/tasks/$taskId').remove();
  }

  @override
  Future<List<TaskModel>> fetchTasks(String userId) async {
    final snapshot = await firebaseDatabase.ref('users/$userId/tasks').get();
    if (snapshot.exists) {
      final tasks = <TaskModel>[];
      for (var child in snapshot.children) {
        tasks.add(TaskModel.fromJson(
          child.key!,
          Map<String, dynamic>.from(child.value as Map),
        ));
      }
      return tasks;
    }
    return [];
  }
}
