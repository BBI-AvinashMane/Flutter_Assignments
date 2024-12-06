// import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
// import 'package:flutter/material.dart';
// import '../../domain/usecases/add_todo.dart';
// import '../../domain/usecases/delete_todo.dart';
// import '../../domain/usecases/edit_todo.dart';
// import '../../domain/usecases/get_todo_list.dart';

// class ToDoProvider extends ChangeNotifier {
//   final GetToDoList getToDoList;
//   final AddToDo addToDo;
//   final EditToDo editToDo;
//   final DeleteToDo deleteToDo;

//   List<ToDoModel> _todoList = [];
//   List<ToDoModel> get todoList => _todoList;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   ToDoProvider({
//     required this.getToDoList,
//     required this.addToDo,
//     required this.editToDo,
//     required this.deleteToDo,
//   }){
//     loadToDos();
//   }

//   Future<void> loadToDos() async {
//     _isLoading = true;
//     notifyListeners();

//     final result = await getToDoList(NoParams());
//     result.fold(
//       (failure) {
//         _todoList = [];
//       },
//       (todos) {
//         _todoList = todos;
//       },
//     );

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> addTask(ToDoModel todo) async {
//     await addToDo(todo);
//     await loadToDos();
//   }

//   Future<void> editTask(ToDoModel todo) async {
//     await editToDo(todo);
//     await loadToDos();
//   }

//   Future<void> deleteTask(String id) async {
//     await deleteToDo(id);
//     await loadToDos();
//   }
// }
