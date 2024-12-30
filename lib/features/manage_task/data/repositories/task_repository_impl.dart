import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/manage_task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final ManageTaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task, String userId) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        userId: userId,
      );
      await remoteDataSource.addTask(taskModel, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to add task: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task, String userId) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        userId: userId,
      );
      await remoteDataSource.updateTask(taskModel, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to update task: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId, String userId) async {
    try {
      await remoteDataSource.deleteTask(taskId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure("Failed to delete task: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> fetchTasks(String userId) async {
    try {
      final taskModels = await remoteDataSource.fetchTasks(userId);
      final tasks = taskModels.map((model) => model as TaskEntity).toList();
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure("Failed to fetch tasks: ${e.toString()}"));
    }
  }
}
