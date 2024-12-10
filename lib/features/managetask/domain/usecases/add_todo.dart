

import 'package:dartz/dartz.dart';
import 'package:to_do_using_bloc/core/error/failures.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import 'package:to_do_using_bloc/features/managetask/domain/repository/todo_repository.dart';

class AddToDo {
  final ToDoRepository repository;

  AddToDo(this.repository);

  Future<Either<Failure, void>> call(ToDoModel todo) async {
    
    return await repository.addToDo(todo);
  }
}
