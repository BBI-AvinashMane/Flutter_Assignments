import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
import '../bloc/authenticate_bloc.dart';

class AuthenticatePage extends StatelessWidget {
  const AuthenticatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.authenticationTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<AuthenticateBloc, AuthenticateState>(
              listener: (context, state) {
                if (state is AuthenticateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is AuthenticateSuccess) {
                  Navigator.pushReplacementNamed(
                    context,
                    Constants.tasksRoute,
                    arguments: state.userId, // Pass userId as a String
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthenticateLoading) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticateBloc>(context)
                            .add(RegisterUserEvent());
                      },
                      child: const Text(Constants.registerButton),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Constants.loginRoute);
                      },
                      child: const Text(Constants.loginButton),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
