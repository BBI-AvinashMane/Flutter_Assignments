import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'injection_container.dart' as di;
import 'features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'features/authenticate/presentation/pages/authenticate_page.dart';
import 'features/manage_task/presentation/pages/task_list.dart';
import 'features/manage_task/presentation/pages/task_form.dart';
import 'features/manage_task/presentation/pages/task_filter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Authentication Bloc
        BlocProvider<AuthenticateBloc>(
          create: (_) => di.sl<AuthenticateBloc>(),
        ),
        // Task Management Bloc
        BlocProvider<TaskBloc>(
          create: (_) => di.sl<TaskBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute, // Use onGenerateRoute for dynamic routes
      ),
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const AuthenticatePage(),
        );
      case '/tasks':
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TaskList(userId: userId),
        );
      case '/task_form':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TaskForm(
            userId: args['userId'] as String,
            task: args['task'], // Pass TaskEntity or null
          ),
        );
      case '/task_filter':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FilterAndSortTasksPage(
            userId: args['userId'] as String,
          ),
        );
      default:
        return null;
    }
  }
}
