import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskParams {
  final TaskEntity task;
  final String userId;

  UpdateTaskParams(this.task, this.userId);
}

class UpdateTask implements UseCase<void, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateTaskParams params) async {
    return await repository.updateTask(params.task, params.userId);
  }
}
