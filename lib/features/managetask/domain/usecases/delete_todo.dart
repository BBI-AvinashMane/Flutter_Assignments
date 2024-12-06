import 'package:dartz/dartz.dart';
import 'package:to_do_using_bloc/core/usecases/usecase.dart';
import 'package:to_do_using_bloc/features/managetask/domain/repository/todo_repository.dart';
import '../../../../../core/error/failures.dart';


class DeleteToDo extends UseCase<void, String> {
  final ToDoRepository repository;

  DeleteToDo(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteToDo(id);
  }
}
