import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
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
        title: const Text(Constants.loginScreenTitle),key: const Key(Constants.appBarLoginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                Constants.userIDInput,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key(Constants.userIdTextField),
                controller: _userIdController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: Constants.userIDInputLabel,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Constants.userIdEmptyValidation;
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
                    Navigator.pushReplacementNamed(context, Constants.tasksRoute,
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
                       key: const Key(Constants.loginButtonKey),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthenticateBloc>(context).add(
                            LoginUserEvent(userId: _userIdController.text.trim()),
                          );
                        }
                      },
                      child: const Text(Constants.loginButton),
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
