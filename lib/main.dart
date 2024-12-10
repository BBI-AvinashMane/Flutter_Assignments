// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:to_do_using_bloc/features/managetask/domain/usecases/add_todo.dart';
// import 'package:to_do_using_bloc/features/managetask/domain/usecases/delete_todo.dart';
// import 'package:to_do_using_bloc/features/managetask/domain/usecases/edit_todo.dart';
// import 'package:to_do_using_bloc/features/managetask/domain/usecases/get_todo_list.dart';

// import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_bloc.dart';

// import 'package:to_do_using_bloc/features/managetask/presentation/pages/todo_page.dart';
// import 'package:to_do_using_bloc/service_locator.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();


//   try {
//   await setupLocator();
//   print('Service Locator Initialized!');
// } catch (e) {
//   print('Service Locator Initialization Failed: $e');
// }


//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'To-Do App',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//       ),
//       home: 
//       BlocProvider<ToDoBloc>(
//         create: (_) => ToDoBloc(
//           addToDo: locator<AddToDo>(),
//           editToDo: locator<EditToDo>(),
//           deleteToDo: locator<DeleteToDo>(),
//           getToDoList: locator<GetToDoList>(),
//         )..add(LoadToDos()),
//      child:  ToDoPage(),
//     ));
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/add_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/delete_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/edit_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/get_todo_list.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/pages/todo_page.dart';
import 'package:to_do_using_bloc/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await setupLocator();
  } catch (e) {
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ToDoBloc>(
          create: (_) => ToDoBloc(
            addToDo: locator<AddToDo>(),
            editToDo: locator<EditToDo>(),
            deleteToDo: locator<DeleteToDo>(),
            getToDoList: locator<GetToDoList>(),
          )..add(LoadToDos()),
        ),
      ],
      child: MaterialApp(
        title: 'To-Do App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const ToDoPage(),
      ),
    );
  }
}
