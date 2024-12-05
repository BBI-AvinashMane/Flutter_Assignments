import 'package:clean_to_do_app/core/usecases/usecase.dart';
import 'package:clean_to_do_app/features/managetask/data/model/todo_model.dart';
import 'package:clean_to_do_app/features/managetask/domain/repository/todo_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../entities/todo.dart';


class EditToDo {
  final ToDoRepository repository;

  EditToDo(this.repository);

  @override
  Future<Either<Failure, void>> call(ToDoModel todo) async {
    return repository.editToDo(todo);
  }
}
