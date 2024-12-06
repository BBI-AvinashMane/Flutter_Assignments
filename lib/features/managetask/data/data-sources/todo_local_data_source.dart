import 'dart:convert';
import 'package:clean_to_do_app/features/managetask/data/model/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ToDoLocalDataSource {
  Future<List<ToDoModel>> getToDoList();
  Future<void> addToDo(ToDoModel todo);
  Future<void> editToDo(ToDoModel todo);
  Future<void> deleteToDo(String id);
}

class ToDoLocalDataSourceImpl implements ToDoLocalDataSource {
  final SharedPreferences sharedPreferences;

  ToDoLocalDataSourceImpl(this.sharedPreferences);

  static const String cachedTodoListKey = 'CACHED_TODO_LIST';

  @override
  Future<List<ToDoModel>> getToDoList() async {
    final jsonString = sharedPreferences.getString(cachedTodoListKey);
    if (jsonString != null) {
      final List decodedList = json.decode(jsonString);
      return decodedList.map((json) => ToDoModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
 @override
Future<void> addToDo(ToDoModel todo) async {
  // Fetch the current list of ToDoModel from SharedPreferences
  final List<ToDoModel> currentList = await getToDoList();

  // Add the new ToDoModel to the current list
  currentList.add(todo);

  // Convert the updated list back to JSON and save it
  final String jsonString =
      json.encode(currentList.map((item) => item.toJson()).toList());
  await sharedPreferences.setString(cachedTodoListKey, jsonString);
}



  @override
  Future<void> editToDo(ToDoModel todo) async {
    final List<ToDoModel> currentList = await getToDoList();
    final updatedList = currentList.map((item) {
      if (item.id == todo.id) {
        return todo; // Replace the existing task with the updated task
      }
      return item;
    }).toList();

    final String jsonString =
        json.encode(updatedList.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(cachedTodoListKey, jsonString);
  }

  @override
  Future<void> deleteToDo(String id) async {
    final List<ToDoModel> currentList = await getToDoList();
    final updatedList = currentList.where((item) => item.id != id).toList();

    final String jsonString =
        json.encode(updatedList.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(cachedTodoListKey, jsonString);
  }
}
