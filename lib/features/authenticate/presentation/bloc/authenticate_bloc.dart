import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import 'authenticate_event.dart';
import 'authenticate_state.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/login_user.dart';


class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  final RegisterUser registerUser;
  final LoginUser loginUser;

  AuthenticateBloc(this.registerUser, this.loginUser)
      : super(AuthenticateInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<LoginUserEvent>(_onLoginUser);
  }

  // Future<void> _onRegisterUser(
  //     RegisterUserEvent event, Emitter<AuthenticateState> emit) async {
  //   emit(AuthenticateLoading());
  //   final result = await registerUser(NoParams());
  //   result.fold(
  //     (failure) => emit(AuthenticateError(failure.message)),
  //     (userId) => emit(AuthenticateSuccess(userId)),
  //   );
  // }
  Future<void> _onRegisterUser(
    RegisterUserEvent event, Emitter<AuthenticateState> emit) async {
  emit(AuthenticateLoading());
  try {
    final result = await registerUser(NoParams());
    result.fold(
      (failure) => emit(AuthenticateError(failure.message)),
      (userId) => emit(AuthenticateSuccess(userId)),
    );
  } catch (e) {
    print("BLoC Error: $e");
    emit(const AuthenticateError("An unexpected error occurred."));
  }
}


  Future<void> _onLoginUser(
      LoginUserEvent event, Emitter<AuthenticateState> emit) async {
    emit(AuthenticateLoading());
    final result = await loginUser(event.userId);
    result.fold(
      (failure) => emit(AuthenticateError(failure.message)),
      (isValid) {
        if (isValid) {
          emit(AuthenticateSuccess(event.userId));
        } else {
          emit(const AuthenticateError("Invalid User ID"));
        }
      },
    );
  }
}
