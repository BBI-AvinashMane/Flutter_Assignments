
part of "todo_bloc.dart";

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
