import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';
import 'package:purchaso/features/product/presentation/pages/bottom_nav.dart';
import 'package:purchaso/features/product/presentation/pages/home_page.dart';
import 'package:purchaso/features/product/presentation/pages/product_details_page.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_event.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_state.dart';
import 'package:purchaso/features/profile/presentation/pages/select_profile_image_page.dart';
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
  setupServiceLocator(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              serviceLocator<AuthBloc>()..add(AppStartedEvent()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => serviceLocator<ProfileBloc>(),
        ),
         BlocProvider<ProductBloc>(
          create: (context) => serviceLocator<ProductBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Purchaso',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthHandler(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/home': (context) {
      final email = ModalRoute.of(context)!.settings.arguments as String;
      return BottomNavigationPage(email);
    },'/select-profile-image': (context) {
            final onImageSelected =
                ModalRoute.of(context)!.settings.arguments as Function(String);
            return SelectProfileImagePage(onImageSelected: onImageSelected);
          },
          // '/home': (context) => HomePage(
          //       username: ModalRoute.of(context)!.settings.arguments as String,
          //     ),
        },
        onGenerateRoute: (settings) {
          if (settings.name == "/profile") {
            final email = settings.arguments as String;
            return MaterialPageRoute(
                builder: (context) => ProfilePage(email: email));
          }
        else if (settings.name == '/product-details') {
            final productId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => ProductDetailsPage(productId: productId),
            );
          }
          return null;
        }
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${authState.error}')),
          );
        }
      },
      builder: (context, authState) { 
       if (authState is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (authState is AuthAuthenticated) {
          BlocProvider.of<ProfileBloc>(context).add(
            CheckProfileCompletionEvent(email: authState.user.email),
          );

          return BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, profileState) {
              if (profileState is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: Unable to check profile.')),
                );
              }
            },
            builder: (context, profileState) {
              print(" profile state in main ${profileState}");
              if (profileState is ProfileCompletionChecked) {
                if (profileState.isProfileComplete) {
                  return BottomNavigationPage(authState.user.email);
                } else {
                  return ProfilePage(email: authState.user.email);
                }
              } 
              return  Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
            },
          );
        } else if (authState is AuthLoggedOut || authState is AuthInitial) {
          return const LoginPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

