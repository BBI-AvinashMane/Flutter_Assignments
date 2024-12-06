import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import '../../../../../core/error/exceptions.dart';

abstract class ToDoLocalDataSource {
  Future<List<ToDoModel>> getToDoList();
  Future<void> addToDo(ToDoModel todo);
  Future<void> editToDo(ToDoModel todo);
  Future<void> deleteToDo(String id);
}

class ToDoLocalDataSourceImpl implements ToDoLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedTodoListKey = 'CACHED_TODO_LIST';

  ToDoLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ToDoModel>> getToDoList() async {
    final jsonString = sharedPreferences.getString(cachedTodoListKey);
    if (jsonString != null) {
      final List decodedList = json.decode(jsonString) as List;
      return decodedList.map((json) => ToDoModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addToDo(ToDoModel todo) async {
    final List<ToDoModel> currentList = await getToDoList();
    currentList.add(todo);
    await _saveToSharedPreferences(currentList);
  }

  @override
  Future<void> editToDo(ToDoModel todo) async {
    final List<ToDoModel> currentList = await getToDoList();
    final updatedList = currentList.map((item) {
      if (item.id == todo.id) {
        return todo; // Replace with the updated task
      }
      return item;
    }).toList();
    await _saveToSharedPreferences(updatedList);
  }

  @override
  Future<void> deleteToDo(String id) async {
    final List<ToDoModel> currentList = await getToDoList();
    final updatedList = currentList.where((item) => item.id != id).toList();
    await _saveToSharedPreferences(updatedList);
  }

  Future<void> _saveToSharedPreferences(List<ToDoModel> todos) async {
    final jsonString = json.encode(todos.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(cachedTodoListKey, jsonString);
  }
}
