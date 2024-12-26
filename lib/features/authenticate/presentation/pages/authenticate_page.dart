import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authenticate_bloc.dart';
import '../bloc/authenticate_event.dart';
import '../bloc/authenticate_state.dart';

class AuthenticatePage extends StatelessWidget {
  const AuthenticatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthenticateBloc, AuthenticateState>(
          builder: (context, state) {
            if (state is AuthenticateSuccess) {
              return Text("User ID: ${state.userId}");
            }
            return const Text("Authenticate");
          },
        ),
      ),
      body: BlocConsumer<AuthenticateBloc, AuthenticateState>(
        listener: (context, state) {
          if (state is AuthenticateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is AuthenticateSuccess) {
            Navigator.pushReplacementNamed(context, '/tasks');
          }
        },
        builder: (context, state) {
          if (state is AuthenticateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticateBloc>().add(RegisterUserEvent());
                  },
                  child: const Text("Register"),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    // Use this to capture login input
                    context.read<AuthenticateBloc>().add(LoginUserEvent(value));
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter User ID",
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final currentState = context.read<AuthenticateBloc>().state;
                    if (currentState is AuthenticateSuccess) {
                      context.read<AuthenticateBloc>().add(
                            LoginUserEvent(currentState.userId),
                          );
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
