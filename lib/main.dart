// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'features/authenticate/presentation/bloc/authenticate_bloc.dart';
// import 'features/authenticate/domain/usecases/login_user.dart';
// import 'features/authenticate/domain/usecases/register_user.dart';
// import 'features/authenticate/presentation/pages/authenticate_page.dart';
// import 'injection_container.dart' as di; // Dependency Injection

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(); // Initialize Firebase
// //   await di.init(); // Initialize dependency injection
// //   runApp(MyApp());
// // }

// import 'package:firebase_database/firebase_database.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp();
//     print("Firebase initialized successfully!");
//     await di.init();

//     // Test Firebase Realtime Database connectivity
//     final database = FirebaseDatabase.instance;
//     await database.ref('test_connection').set({
//       'timestamp': DateTime.now().toIso8601String(),
//     });
//     print("Database test write successful!");
//   } catch (e) {
//     print("Firebase initialization or database test failed: $e");
//   }
//   runApp(MyApp());
// }
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => AuthenticateBloc(
//             di.sl<RegisterUser>(),
//             di.sl<LoginUser>(),
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Task Manager Firebase',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         initialRoute: '/',
//         routes: {
//           '/': (context) => const AuthenticatePage(),
//           '/tasks': (context) => Scaffold(
//                 appBar: AppBar(title: const Text("Task Management")),
//                 body: const Center(child: Text("Task Page Placeholder")),
//               ),
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_state.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/pages/task_list.dart';
import 'features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'features/authenticate/domain/usecases/login_user.dart';
import 'features/authenticate/domain/usecases/register_user.dart';
import 'features/manage_task/presentation/bloc/task_bloc.dart';
import 'features/manage_task/domain/usecases/get_task.dart';
import 'features/manage_task/domain/usecases/filter_and_sort_task.dart';
import 'features/manage_task/domain/usecases/delete_task.dart';
import 'features/authenticate/presentation/pages/authenticate_page.dart';
import 'injection_container.dart' as di; // Dependency Injection

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialize Firebase
    print("Firebase initialized successfully!");
    await di.init(); // Initialize dependency injection

    // Test Firebase Realtime Database connectivity
    final database = di.sl<FirebaseDatabase>();
    await database.ref('test_connection').set({
      'timestamp': DateTime.now().toIso8601String(),
    });
    print("Database test write successful!");
  } catch (e) {
    print("Firebase initialization or database test failed: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Authentication Bloc
        BlocProvider(
          create: (_) => AuthenticateBloc(
            di.sl<RegisterUser>(),
            di.sl<LoginUser>(),
          ),
        ),
        // Task Management Bloc
        BlocProvider(
          create: (_) => TaskBloc(
            getTasks: di.sl<GetTasks>(),
            filterAndSortTasks: di.sl<FilterAndSortTasks>(),
            preferences: di.sl(),
            deleteTask: di.sl<DeleteTask>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager Firebase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          // Authentication Page
          '/': (context) => const AuthenticatePage(),
          // Task List Page
          '/tasks': (context) => BlocBuilder<AuthenticateBloc, AuthenticateState>(
                builder: (context, state) {
                  if (state is AuthenticateSuccess) {
                    return TaskList(userId: state.userId);
                  }
                  return const AuthenticatePage();
                },
              ),
        },
      ),
    );
  }
}
