import 'package:clean_to_do_app/core/usecases/usecase.dart';
import 'package:clean_to_do_app/features/managetask/data/model/todo_model.dart';
import 'package:clean_to_do_app/features/managetask/domain/repository/todo_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';

class GetToDoList {
  final ToDoRepository repository;

  GetToDoList(this.repository);

  @override
  Future<Either<Failure, List<ToDoModel>>> call(NoParams params) async {
    return repository.getToDoList();
  }
}

class NoParams {
}
