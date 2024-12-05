import 'package:clean_to_do_app/features/managetask/data/data-sources/todo_local_data_source.dart';
import 'package:clean_to_do_app/features/managetask/data/model/todo_model.dart';
import 'package:clean_to_do_app/features/managetask/domain/repository/todo_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';

class ToDoRepositoryImpl implements ToDoRepository {
  final ToDoLocalDataSource localDataSource;

  ToDoRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ToDoModel>>> getToDoList() async {
    try {
      final todos = await localDataSource.getToDoList();
      return Right(todos);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToDo(ToDoModel todo) async {
    try {
      final todos = await localDataSource.getToDoList();
      final todoModel = ToDoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
      );
      todos.add(todoModel);
      await localDataSource.addToDo(todos);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editToDo(ToDoModel todo) async {
    try {
      final todos = await localDataSource.getToDoList();
      final updatedTodos = todos.map((model) {
        if (model.id == todo.id) {
          return ToDoModel(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            isCompleted: todo.isCompleted,
          );
        }
        return model;
      }).toList();
      await localDataSource.addToDo(updatedTodos);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteToDo(String id) async {
    try {
      final todos = await localDataSource.getToDoList();
      final filteredTodos = todos.where((model) => model.id != id).toList();
      await localDataSource.addToDo(filteredTodos);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
