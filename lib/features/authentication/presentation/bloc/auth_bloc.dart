import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/authentication/domain/entities/user.dart';
import 'package:purchaso/features/authentication/presentation/bloc/auth_event.dart';
import 'package:purchaso/features/authentication/presentation/bloc/auth_state.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // Handle AppStartedEvent for session persistence
    on<AppStartedEvent>(_handleAppStartedEvent);

    // Handle LoginEvent
    on<LoginEvent>(_handleLoginEvent);

    // Handle RegisterEvent
    on<RegisterEvent>(_handleRegisterEvent);

    // Handle GoogleLoginEvent
    on<GoogleLoginEvent>(_handleGoogleLoginEvent);

    // Handle ForgotPasswordEvent
    on<ForgotPasswordEvent>(_handleForgotPasswordEvent);

    // Handle LogoutEvent
    on<LogoutEvent>(_handleLogoutEvent);
  }

// Future<void> _handleAppStartedEvent(
//     AppStartedEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     debugPrint("AppStartedEvent triggered");
//     emit(AuthLoading());
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     if (isLoggedIn) {
//       final email = prefs.getString('email') ?? '';
//       final username = prefs.getString('username') ?? '';
//       if (email.isNotEmpty && state is! AuthAuthenticated) {
//         emit(AuthAuthenticated(User(email: email, username: username)));
//       } else {
//         emit(AuthInitial());
//       }
//     } else {
//       emit(AuthInitial());
//     }
//   }


Future<void> _handleAppStartedEvent(
  AppStartedEvent event,
  Emitter<AuthState> emit,
) async {

 
  emit(AuthLoading());
  final prefs = await SharedPreferences.getInstance();
  try {
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final email = prefs.getString('email') ?? '';
      final username = prefs.getString('username') ?? '';
      if (email.isNotEmpty && state is! AuthAuthenticated) {
        // debugPrint("Restoring Authenticated State for: $username");
        await Future.delayed(Duration.zero); // Ensure proper state handling
        emit(AuthAuthenticated(User(email: email, username: username)));
      } else {
        // debugPrint("Incomplete user data or already authenticated.");
        emit(AuthInitial());
      }
    } else {
      // debugPrint("No user logged in, emitting AuthInitial");
      emit(AuthInitial());
    }
  } catch (e) {
    // debugPrint("Error accessing SharedPreferences: $e");
    emit(AuthError("Failed to load user data"));
  }
}

  Future<void> _handleLoginEvent(
  LoginEvent event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());
  // print("LoginEvent triggered with email: ${event.email}");
  final result = await authRepository.login(event.email, event.password);

  await result.fold(
    (exception) async {
      // print("Login failed: $exception");
      emit(AuthError('Login failed: ${exception.toString()}'));
    },
    (user)  async{
      // print("Login successful for user: ${user.email}");
      await _saveUserToPreferences(user);
      // BlocProvider.of<ProfileBloc>(context).add(ResetProfileEvent());
      emit(AuthAuthenticated(user));
    },
  );
}


  Future<void> _handleRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // print("registring user for you please dont show login page");
    final result = await authRepository.register(event.email, event.password);

    await result.fold(
      (exception) async {
        emit(AuthError('Registration failed: ${exception.toString()}'));
      },
      (user) async {
        await _saveUserToPreferences(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _handleGoogleLoginEvent(
    GoogleLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.loginWithGoogle();

    await result.fold(
      (exception) async {
        emit(AuthError('Google login failed: ${exception.toString()}'));
      },
      (user) async {
        await _saveUserToPreferences(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _handleForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.sendPasswordReset(event.email);

    await result.fold(
      (exception) async {
        emit(AuthError('Password reset failed: ${exception.toString()}'));
      },
      (_) async {
        emit(AuthInitial());
      },
    );
  }

  Future<void> _handleLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

 Future<void> _saveUserToPreferences(User user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('email', user.email);
  await prefs.setString('username', user.username);
  // print("User saved in SharedPreferences: ${user.email}");
}
// @override
// void onTransition(Transition<AuthEvent, AuthState> transition) {
//   super.onTransition(transition);
//   debugPrint('State Transition: ${transition.currentState} -> ${transition.nextState}');
// }
}
