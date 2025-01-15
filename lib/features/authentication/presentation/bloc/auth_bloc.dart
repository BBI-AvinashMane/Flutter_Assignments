import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/authentication/presentation/bloc/auth_event.dart';
import 'package:purchaso/features/authentication/presentation/bloc/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {

      
     // emit(AuthLoading());
      final result = await authRepository.login(event.email, event.password);
      result.fold(
        (exception){
         
          emit(AuthError(exception.toString()));
        },
        (user) {
         
        emit(AuthAuthenticated(user));

        } 
      );
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.register(event.email, event.password);
      result.fold(
        (exception) => emit(AuthError(exception.toString())),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<GoogleLoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.loginWithGoogle();
      result.fold(
        (exception) => emit(AuthError(exception.toString())),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.sendPasswordReset(event.email);
      result.fold(
        (exception) => emit(AuthError(exception.toString())),
        (_) => emit(AuthInitial()),
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.logout();
      result.fold(
        (exception) => emit(AuthError(exception.toString())),
        (_) => emit(AuthLoggedOut()),
      );
    });
  }
}
