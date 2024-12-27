import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, void>> addTask(TaskEntity task, String userId);
  Future<Either<Failure, void>> updateTask(TaskEntity task, String userId);
  Future<Either<Failure, void>> deleteTask(String taskId, String userId);
  Future<Either<Failure, List<TaskEntity>>> fetchTasks(String userId);
}
