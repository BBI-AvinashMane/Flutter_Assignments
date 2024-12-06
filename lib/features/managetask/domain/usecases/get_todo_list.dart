import 'package:dartz/dartz.dart';
import 'package:to_do_using_bloc/core/usecases/usecase.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import 'package:to_do_using_bloc/features/managetask/domain/repository/todo_repository.dart';
import '../../../../../core/error/failures.dart';


class GetToDoList extends UseCase<List<ToDoModel>, NoParams> {
  final ToDoRepository repository;

  GetToDoList(this.repository);

  @override
  Future<Either<Failure, List<ToDoModel>>> call(NoParams params) async {
    return await repository.getToDoList();
  }
}

class NoParams {
}
