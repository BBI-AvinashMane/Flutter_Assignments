import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'features/authenticate/domain/usecases/login_user.dart';
import 'features/authenticate/domain/usecases/register_user.dart';
import 'features/authenticate/presentation/pages/authenticate_page.dart';
import 'injection_container.dart' as di; // Dependency Injection

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   await di.init(); // Initialize dependency injection
//   runApp(MyApp());
// }

import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully!");
    await di.init();

    // Test Firebase Realtime Database connectivity
    final database = FirebaseDatabase.instance;
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
        BlocProvider(
          create: (_) => AuthenticateBloc(
            di.sl<RegisterUser>(),
            di.sl<LoginUser>(),
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
          '/': (context) => const AuthenticatePage(),
          '/tasks': (context) => Scaffold(
                appBar: AppBar(title: const Text("Task Management")),
                body: const Center(child: Text("Task Page Placeholder")),
              ),
        },
      ),
    );
  }
}