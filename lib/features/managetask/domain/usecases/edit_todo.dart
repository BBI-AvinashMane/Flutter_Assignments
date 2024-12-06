import 'package:dartz/dartz.dart';
import 'package:to_do_using_bloc/core/usecases/usecase.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import 'package:to_do_using_bloc/features/managetask/domain/repository/todo_repository.dart';
import '../../../../../core/error/failures.dart';

class EditToDo extends UseCase<void, ToDoModel> {
  final ToDoRepository repository;

  EditToDo(this.repository);

  @override
  Future<Either<Failure, void>> call(ToDoModel todo) async {
    return await repository.editToDo(todo);
  }
}
