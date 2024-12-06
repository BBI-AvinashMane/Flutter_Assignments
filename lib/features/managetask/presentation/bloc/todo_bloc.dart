import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/add_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/delete_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/edit_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/get_todo_list.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_event.dart';
import 'todo_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final AddToDo addToDo;
  final EditToDo editToDo;
  final DeleteToDo deleteToDo;
  final GetToDoList getToDoList;

  ToDoBloc({
    required this.addToDo,
    required this.editToDo,
    required this.deleteToDo,
    required this.getToDoList,
  }) : super(ToDoInitial()) {
    on<LoadToDos>(_onLoadToDos);
    on<AddToDoEvent>(_onAddToDo);
    on<EditToDoEvent>(_onEditToDo);
    on<DeleteToDoEvent>(_onDeleteToDo);
  }

  Future<void> _onLoadToDos(LoadToDos event, Emitter<ToDoState> emit) async {
    emit(ToDoLoading());
    final result = await getToDoList(NoParams());
    result.fold(
      (failure) => emit(ToDoError(message: 'Failed to load tasks')),
      (todos) => emit(ToDoLoaded(todos: todos)),
    );
  }

  Future<void> _onAddToDo(AddToDoEvent event, Emitter<ToDoState> emit) async {
    final newTodo = ToDoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title,
      description: event.description,
      isCompleted: false,
    );
    await addToDo(newTodo);
    add(LoadToDos());
  }

  Future<void> _onEditToDo(EditToDoEvent event, Emitter<ToDoState> emit) async {
    final updatedTodo = ToDoModel(
      id: event.id,
      title: event.title,
      description: event.description,
      isCompleted: event.isCompleted,
    );
    await editToDo(updatedTodo);
    add(LoadToDos());
  }

  Future<void> _onDeleteToDo(
      DeleteToDoEvent event, Emitter<ToDoState> emit) async {
    await deleteToDo(event.id);
    add(LoadToDos());
  }
}
