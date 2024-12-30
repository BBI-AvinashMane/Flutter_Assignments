import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';

// class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
//   final RegisterUser registerUser;
//   final LoginUser loginUser;
//   final LogoutUser logoutUser;
//   final SharedPreferences preferences;

//   static const String loggedInUserKey = "loggedInUser";

//   AuthenticateBloc(
//       this.registerUser, this.loginUser, this.logoutUser, this.preferences)
//       : super(AuthenticateInitial()) {
//     on<RegisterUserEvent>(_onRegisterUser);
//     on<LoginUserEvent>(_onLoginUser);
//     on<LogoutEvent>(_onLogout);

//     // Restore session state during initialization
//     _restoreLoginState();
//   }

//   Future<void> _onRegisterUser(
//       RegisterUserEvent event, Emitter<AuthenticateState> emit) async {
//     emit(AuthenticateLoading());
//     try {
//       final result = await registerUser(NoParams());
//       result.fold(
//         (failure) => emit(AuthenticateError(failure.message)),
//         (userId) {
//           preferences.setString(loggedInUserKey, userId); // Save user ID
//           emit(AuthenticateSuccess(userId));
//         },
//       );
//     } catch (e, stackTrace) {
//       print("Error in _onRegisterUser: $e");
//       print("StackTrace: $stackTrace");
//       emit(const AuthenticateError(
//           "An unexpected error occurred while registering the user."));
//     }
//   }

//   Future<void> _onLoginUser(
//       LoginUserEvent event, Emitter<AuthenticateState> emit) async {
//     emit(AuthenticateLoading());
//     try {
//       final result = await loginUser(event.userId);
//       result.fold(
//         (failure) => emit(AuthenticateError(failure.message)),
//         (isValid) {
//           if (isValid) {
//             preferences.setString(loggedInUserKey, event.userId); // Save user ID
//             emit(AuthenticateSuccess(event.userId));
//           } else {
//             emit(const AuthenticateError("Invalid User ID"));
//           }
//         },
//       );
//     } catch (e, stackTrace) {
//       print("Error in _onLoginUser: $e");
//       print("StackTrace: $stackTrace");
//       emit(const AuthenticateError(
//           "An unexpected error occurred while logging in."));
//     }
//   }

//   // Future<void> _onLogout(
//   //     LogoutEvent event, Emitter<AuthenticateState> emit) async {
//   //   emit(AuthenticateLoading());
//   //   try {
//   //     final result = await logoutUser(NoParams());
//   //     result.fold(
//   //       (failure) => emit(AuthenticateError(failure.message)),
//   //       (_) {
//   //         emit(Unauthenticated());
//   //       },
//   //     );
//   //   } catch (e, stackTrace) {
//   //     print("Error in _onLogout: $e");
//   //     print("StackTrace: $stackTrace");
//   //     emit(const AuthenticateError(
//   //         "An unexpected error occurred while logging out."));
//   //   }
//   // }
//   Future<void> _onLogout(
//     LogoutEvent event, Emitter<AuthenticateState> emit) async {
//   emit(AuthenticateLoading());
//   try {
//     final result = await logoutUser(NoParams());
//     result.fold(
//       (failure) => emit(AuthenticateError(failure.message)),
//       (_) {
//         emit(Unauthenticated());
//       },
//     );
//   } catch (e, stackTrace) {
//     print("Error in _onLogout: $e");
//     print("StackTrace: $stackTrace");
//     emit(const AuthenticateError(
//         "An unexpected error occurred while logging out."));
//   }
// }

//   void _restoreLoginState() {
//     final savedUserId = preferences.getString(loggedInUserKey);
//     if (savedUserId != null) {
//       add(LoginUserEvent(savedUserId));
//     }
//   }
// }
part 'authenticate_event.dart';
part 'authenticate_state.dart';

class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final SharedPreferences preferences;

  AuthenticateBloc({
    required this.registerUser,
    required this.loginUser,
    required this.logoutUser,
    required this.preferences,
  }) : super(AuthenticateInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<LoginUserEvent>(_onLoginUser);
    on<LogoutEvent>(_onLogout);

    // Restore the user session on app startup
    _restoreLoginState();
  }

  /// Restores the user session if previously logged in
  Future<void> _restoreLoginState() async {
    final userId = preferences.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      add(LoginUserEvent(userId: userId));
    }
  }

  /// Handles user registration
  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<AuthenticateState> emit,
  ) async {
    emit(AuthenticateLoading());
    final result = await registerUser.call(NoParams());
    result.fold(
      (failure) => emit(AuthenticateError(failure.message)),
      (userId) {
        preferences.setString('userId', userId);
        emit(AuthenticateSuccess(userId: userId));
      },
    );
  }

  /// Handles user login
  Future<void> _onLoginUser(
    LoginUserEvent event,
    Emitter<AuthenticateState> emit,
  ) async {
    emit(AuthenticateLoading());
    final result = await loginUser.call(event.userId);
    result.fold(
      (failure) => emit(AuthenticateError(failure.message)),
      (isValid) {
        if (isValid) {
          preferences.setString('userId', event.userId);
          emit(AuthenticateSuccess(userId: event.userId));
        } else {
          emit(AuthenticateError("Invalid User ID"));
        }
      },
    );
  }

  /// Handles user logout
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthenticateState> emit,
  ) async {
    emit(AuthenticateLoading());
    final result = await logoutUser.call(NoParams());
    result.fold(
      (failure) => emit(AuthenticateError(failure.message)),
      (_) {
        preferences.remove('userId');
        emit(Unauthenticated());
      },
    );
  }
}
