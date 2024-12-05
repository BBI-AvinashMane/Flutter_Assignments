import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/todo_model.dart';

abstract class ToDoRepository {
  Future<Either<Failure, List<ToDoModel>>> getToDoList();
  Future<Either<Failure, void>> addToDo(ToDoModel todo);
  Future<Either<Failure, void>> editToDo(ToDoModel todo);
  Future<Either<Failure, void>> deleteToDo(String id);
}
