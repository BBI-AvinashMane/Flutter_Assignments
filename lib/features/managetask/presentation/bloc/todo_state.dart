import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';

abstract class ToDoState {}

class ToDoInitial extends ToDoState {}

class ToDoLoading extends ToDoState {}

class ToDoLoaded extends ToDoState {
  final List<ToDoModel> todos;

  ToDoLoaded({required this.todos});
}

class ToDoError extends ToDoState {
  final String message;

  ToDoError({required this.message});
}
