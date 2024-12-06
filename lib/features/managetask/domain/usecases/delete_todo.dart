
import 'package:clean_to_do_app/features/managetask/domain/repository/todo_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';

class DeleteToDo {
  final ToDoRepository repository;

  DeleteToDo(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return repository.deleteToDo(id);
  }
}

