import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, void>> call(String taskId,String userId) async {
    return await repository.deleteTask(taskId,userId);
  }
}
