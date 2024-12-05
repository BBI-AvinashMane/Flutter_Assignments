
import 'package:clean_to_do_app/features/managetask/data/model/todo_model.dart';
import 'package:clean_to_do_app/features/managetask/domain/repository/todo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/error/failures.dart';
import 'package:clean_to_do_app/core/usecases/usecase.dart';

class AddToDo  {
  final ToDoRepository repository;

  AddToDo(this.repository);

  @override
  Future<Either<Failure, void>> call(ToDoModel todo) async {
    final todoWithId = ToDoModel(
      id: const Uuid().v4(),
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
    );
    return repository.addToDo(todoWithId);
  }
}

