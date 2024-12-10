import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/add_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/delete_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/edit_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/get_todo_list.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final AddToDo _addToDo;
  final EditToDo _editToDo;
  final DeleteToDo _deleteToDo;
  final GetToDoList _getToDoList;

  ToDoBloc({
    required AddToDo addToDo,
    required EditToDo editToDo,
    required DeleteToDo deleteToDo,
    required GetToDoList getToDoList,
  })  : _addToDo = addToDo,
        _editToDo = editToDo,
        _deleteToDo = deleteToDo,
        _getToDoList = getToDoList,
        super(ToDoInitial()) {
    debugPrint('ToDoBloc constructor called');
    on<LoadToDos>(_onLoadToDos);
    on<AddToDoEvent>(_onAddToDo);
    on<EditToDoEvent>(_onEditToDo);
    on<DeleteToDoEvent>(_onDeleteToDo);
  }

  Future<void> _onLoadToDos(LoadToDos event, Emitter<ToDoState> emit) async {
    emit(ToDoLoading());
    try {
      final result = await _getToDoList.call(NoParams());
      result.fold(
        (failure) {
          emit(ToDoError(message: 'Failed to load tasks'));
        },
        (todos) {
          emit(ToDoLoaded(todos: todos));
        },
      );
    } catch (e) {
      emit(ToDoError(message: 'Unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onAddToDo(AddToDoEvent event, Emitter<ToDoState> emit) async {
    try {
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(ToDoError(message: 'Title and description cannot be empty'));
        return;
      }
      final newTodo = ToDoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        isCompleted: false,
      );
      await _addToDo.call(newTodo);

      if (state is ToDoLoaded) {
        final currentState = state as ToDoLoaded;
        final updatedTodos = List<ToDoModel>.from(currentState.todos)..add(newTodo);
        emit(ToDoLoaded(todos: updatedTodos));
      } else {
        debugPrint('State is not ToDoLoaded; falling back to LoadToDos.');
        add(LoadToDos());
      }
    } catch (e) {
      emit(ToDoError(message: 'Failed to add task: ${e.toString()}'));
    }
  }

  Future<void> _onEditToDo(EditToDoEvent event, Emitter<ToDoState> emit) async {
    try {
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(ToDoError(message: 'Title and description cannot be empty'));
        return;
      }
      final updatedTodo = ToDoModel(
        id: event.id,
        title: event.title,
        description: event.description,
        isCompleted: event.isCompleted,
      );
      await _editToDo.call(updatedTodo);

      if (state is ToDoLoaded) {
        final currentState = state as ToDoLoaded;
        final updatedTodos = currentState.todos.map((todo) {
          return todo.id == event.id ? updatedTodo : todo;
        }).toList();
        emit(ToDoLoaded(todos: updatedTodos));
      } else {
        debugPrint('State is not ToDoLoaded; falling back to LoadToDos.');
        add(LoadToDos());
      }
    } catch (e) {
      emit(ToDoError(message: 'Failed to edit task: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteToDo(DeleteToDoEvent event, Emitter<ToDoState> emit) async {
    try {
      await _deleteToDo.call(event.id);

      if (state is ToDoLoaded) {
        final currentState = state as ToDoLoaded;
        final updatedTodos =
            currentState.todos.where((todo) => todo.id != event.id).toList();
        emit(ToDoLoaded(todos: updatedTodos));
      } else {
        debugPrint('State is not ToDoLoaded; falling back to LoadToDos.');
        add(LoadToDos());
      }
    } catch (e) {
      emit(ToDoError(message: 'Failed to delete task: ${e.toString()}'));
    }
  }
}
