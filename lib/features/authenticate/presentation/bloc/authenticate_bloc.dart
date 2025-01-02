import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
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

  Future<void> _onLogout(
  LogoutEvent event,
  Emitter<AuthenticateState> emit,
) async {
  emit(AuthenticateLoading());
  final result = await logoutUser.call(NoParams());
  result.fold(
    (failure) => emit(AuthenticateError(failure.message)),
    (_) {
      // Clear persisted user ID
      preferences.remove('userId'); 

      // Reset TaskBloc state
      final taskBloc = BlocProvider.of<TaskBloc>(event.context);
      taskBloc.add(const LoadTasksEvent('')); // Reset tasks by loading empty user

      emit(Unauthenticated());
    },
  );
}

}
