import 'package:clean_to_do_app/features/managetask/data/data-sources/todo_local_data_source.dart';
import 'package:clean_to_do_app/features/managetask/data/repository/todo_repository_impl.dart';
import 'package:clean_to_do_app/features/managetask/domain/usecases/add_todo.dart';
import 'package:clean_to_do_app/features/managetask/domain/usecases/delete_todo.dart';
import 'package:clean_to_do_app/features/managetask/domain/usecases/edit_todo.dart';
import 'package:clean_to_do_app/features/managetask/domain/usecases/get_todo_list.dart';
import 'package:clean_to_do_app/features/managetask/presentation/pages/todo_page.dart';
import 'package:clean_to_do_app/features/managetask/presentation/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency setup
  final sharedPreferences = await SharedPreferences.getInstance();
  final localDataSource = ToDoLocalDataSourceImpl(sharedPreferences);
  final repository = ToDoRepositoryImpl(localDataSource);

  // Initialize use cases
  final getToDoList = GetToDoList(repository);
  final addToDo = AddToDo(repository);
  final editToDo = EditToDo(repository);
  final deleteToDo = DeleteToDo(repository);

  runApp(MyApp(
    getToDoList: getToDoList,
    addToDo: addToDo,
    editToDo: editToDo,
    deleteToDo: deleteToDo,
  ));
}

class MyApp extends StatelessWidget {
  final GetToDoList getToDoList;
  final AddToDo addToDo;
  final EditToDo editToDo;
  final DeleteToDo deleteToDo;

  const MyApp({
    super.key,
    required this.getToDoList,
    required this.addToDo,
    required this.editToDo,
    required this.deleteToDo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ToDoProvider(
            getToDoList: getToDoList,
            addToDo: addToDo,
            editToDo: editToDo,
            deleteToDo: deleteToDo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const ToDoPage(),
      ),
    );
  }
}
