
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/pages/login_page.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'injection_container.dart' as di;
import 'features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'features/authenticate/presentation/pages/authenticate_page.dart';
import 'features/manage_task/presentation/pages/task_list.dart';
import 'features/manage_task/presentation/pages/task_form.dart';
import 'features/manage_task/presentation/pages/task_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const AuthenticatePage(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
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
          builder: (_) => TaskFilterPage(
            userId: args['userId'] as String,
            priorityLevel: args['priorityLevel'] as String?, // Optional priority level
          ),
        );
      case '/logout':
        return MaterialPageRoute(
          builder: (_) => LogoutScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("404 - Page Not Found")),
            body: const Center(child: Text("Page not found.")),
          ),
        );
    }
  }
}

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _clearPreferencesAndLogout(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const AuthenticatePage(); // Redirect to AuthenticatePage
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<void> _clearPreferencesAndLogout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('filterByPriority');
    await preferences.remove('priorityLevel');
    await preferences.remove('filterByDueDate');
    await preferences.remove('userId');
  }
}
