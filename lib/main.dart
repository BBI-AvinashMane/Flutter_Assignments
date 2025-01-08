
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
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
        title: Constants.appName,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: Constants.route,
        onGenerateRoute: _onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Constants.route:
        return MaterialPageRoute(
          builder: (_) => const AuthenticatePage(),
        );
      case Constants.loginRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case Constants.tasksRoute:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TaskList(userId: userId),
        );
      case Constants.taskFormRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TaskForm(
            userId: args[Constants.userId] as String,
            task: args[Constants.task], // Pass TaskEntity or null
          ),
        );
      case Constants.taskFilterRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TaskFilterPage(
            userId: args[Constants.userId] as String,
            priorityLevel: args[Constants.priorityLevel] as String?, // Optional priority level
          ),
        );
      case Constants.logOutRoute:
        return MaterialPageRoute(
          builder: (_) => LogoutScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text(Constants.pageError)),
            body: const Center(child: Text(Constants.pageNotFoundError)),
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
    await preferences.remove(Constants.filterByPriority);
    await preferences.remove(Constants.priorityLevel);
    await preferences.remove(Constants.filterByDueDate);
    await preferences.remove(Constants.userId);
  }
}
