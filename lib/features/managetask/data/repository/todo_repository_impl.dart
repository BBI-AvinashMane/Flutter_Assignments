import 'package:dartz/dartz.dart';
import 'package:to_do_using_bloc/features/managetask/data/data-sources/todo_local_data_source.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import 'package:to_do_using_bloc/features/managetask/domain/repository/todo_repository.dart';
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
      await localDataSource.addToDo(todo);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editToDo(ToDoModel todo) async {
    try {
      await localDataSource.editToDo(todo);
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
