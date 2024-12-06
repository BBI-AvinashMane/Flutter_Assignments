import 'package:dartz/dartz.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import '../../../../../core/error/failures.dart';

abstract class ToDoRepository {
  Future<Either<Failure, List<ToDoModel>>> getToDoList();
  Future<Either<Failure, void>> addToDo(ToDoModel todo);
  Future<Either<Failure, void>> editToDo(ToDoModel todo);
  Future<Either<Failure, void>> deleteToDo(String id);
}
