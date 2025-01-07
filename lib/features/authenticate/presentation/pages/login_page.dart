import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authenticate_bloc.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),key: const Key('appBarLoginTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your User ID to log in:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('userIdTextField'),
                controller: _userIdController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'User ID cannot be empty';
                  }
                  // if (!value.startsWith('user_')) {
                  //   return 'User ID must start with "user_"';
                  // }
                   return null;
                 },
              ),
              const SizedBox(height: 16),
              BlocConsumer<AuthenticateBloc, AuthenticateState>(
                listener: (context, state) {
                  if (state is AuthenticateError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is AuthenticateSuccess) {
                    Navigator.pushReplacementNamed(context, '/tasks',
                        arguments: state.userId);
                  }
                },
                builder: (context, state) {
                  if (state is AuthenticateLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                       key: const Key('loginButton'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthenticateBloc>(context).add(
                            LoginUserEvent(userId: _userIdController.text.trim()),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}
