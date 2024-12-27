import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call(String userId) {
    return repository.fetchTasks(userId);
  }
}
