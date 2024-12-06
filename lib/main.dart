import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_event.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/pages/todo_page.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the service locator
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider(
        create: (context) => sl<ToDoBloc>()..add(LoadToDos()),
        child: const ToDoPage(),
      ),
    );
  }
}
