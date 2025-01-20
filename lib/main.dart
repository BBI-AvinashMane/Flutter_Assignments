import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:purchaso/features/product/presentation/pages/home_page.dart';
import 'package:purchaso/service_locator.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/presentation/pages/signup_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/authentication/presentation/bloc/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator(); // Initialize Service Locator
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => serviceLocator<AuthBloc>()..add(AppStartedEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Purchaso',
        theme: ThemeData(primarySwatch: Colors.blue),
        // home: const AuthHandler(),
        initialRoute: '/',
        routes: {
         '/': (context) => const AuthHandler(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/profile': (context) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return ProfilePage(email: state.user.email);
                  }
                  return const LoginPage();
                },
              ),
          '/home': (context) => HomePage(
                username: ModalRoute.of(context)!.settings.arguments as String,
              ),
        },
      ),
    );
  }
}


class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navigation based on states
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/profile',arguments: state.user.username,);
        } else if (state is AuthLoggedOut) {
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        // UI rendering based on states
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          return ProfilePage(email: state.user.email);
        } 
        else if (state is AuthLoggedOut || state is AuthInitial) {
          return const LoginPage();
        } 
        else if (state is AuthError) {
          return const LoginPage(); 
        } else {
          return const Scaffold(
            body: Center(child: Text('Unexpected state! Please restart the app.')),
          );
        }
      },
    );
  }
}
