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
      // Convert ToDoModel to ToDo (Domain Entity)
      final todoEntities = todos.map((model) => model.toEntity()).toList();
      return Right(todoEntities);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToDo(ToDoModel todo) async {
    try {
      // Convert ToDo (Domain Entity) to ToDoModel (Data Model)
      final todoModel = ToDoModel.fromEntity(todo);
      await localDataSource.addToDo(todoModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editToDo(ToDoModel todo) async {
 
    try {
      // Convert ToDo (Domain Entity) to ToDoModel (Data Model)
      final todoModel = ToDoModel.fromEntity(todo);
      await localDataSource.editToDo(todoModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteToDo(String id) async {
    try {
      await localDataSource.deleteToDo(id);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
