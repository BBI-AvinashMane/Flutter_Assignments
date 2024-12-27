import 'package:dartz/dartz.dart';
import 'package:task_manager_firebase/core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<Either<Failure, void>> call(TaskEntity task, String userId) async {
    return await repository.addTask(task, userId);
  }
}

