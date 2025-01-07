// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:task_manager_firebase/core/usecases/usecase.dart';
// import 'package:task_manager_firebase/core/error/failures.dart';
// import 'package:task_manager_firebase/features/authenticate/domain/usecases/register_user.dart';
// import 'package:task_manager_firebase/features/authenticate/domain/usecases/login_user.dart';
// import 'package:task_manager_firebase/features/authenticate/domain/usecases/logout_user.dart';
// import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart';
// import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
// import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart';
// import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart' as auth;
// import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart' as task;


// class MockRegisterUser extends Mock implements RegisterUser {}

// class MockLoginUser extends Mock implements LoginUser {}

// class MockLogoutUser extends Mock implements LogoutUser {}

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// class MockTaskBloc extends Mock implements TaskBloc {}

// void main() {
//   late MockRegisterUser mockRegisterUser;
//   late MockLoginUser mockLoginUser;
//   late MockLogoutUser mockLogoutUser;
//   late MockSharedPreferences mockPreferences;
//   late MockTaskBloc mockTaskBloc;
//   late AuthenticateBloc authenticateBloc;

//   setUp(() {
//     mockRegisterUser = MockRegisterUser();
//     mockLoginUser = MockLoginUser();
//     mockLogoutUser = MockLogoutUser();
//     mockPreferences = MockSharedPreferences();
//     mockTaskBloc = MockTaskBloc();

//     authenticateBloc = AuthenticateBloc(
//       registerUser: mockRegisterUser,
//       loginUser: mockLoginUser,
//       logoutUser: mockLogoutUser,
//       preferences: mockPreferences,
//     );

//     registerFallbackValue(NoParams());
//   });

//   tearDown(() {
//     authenticateBloc.close();
//   });

//   group('AuthenticateBloc', () {
//     test('initial state is AuthenticateInitial', () {
//       expect(authenticateBloc.state, AuthenticateInitial());
//     });

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'restores session when userId exists in SharedPreferences',
//       build: () {
//         when(() => mockPreferences.getString('userId')).thenReturn('user_1');
//         when(() => mockLoginUser.call('user_1')).thenAnswer((_) async => Right(true));
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc,
//       expect: () => [
//         AuthenticateLoading(),
//         AuthenticateSuccess(userId: 'user_1'),
//       ],
//     );

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'emits [AuthenticateLoading, AuthenticateSuccess] on successful registration',
//       build: () {
//         when(() => mockRegisterUser.call(any()))
//             .thenAnswer((_) async => Right('user_1'));
//         when(() => mockPreferences.setString(any(), any()))
//             .thenAnswer((_) async => true);
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc.add(RegisterUserEvent()),
//       expect: () => [
//         AuthenticateLoading(),
//         AuthenticateSuccess(userId: 'user_1'),
//       ],
//       verify: (_) {
//         verify(() => mockPreferences.setString('userId', 'user_1')).called(1);
//       },
//     );

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'emits [AuthenticateLoading, AuthenticateError] on registration failure',
//       build: () {
//         when(() => mockRegisterUser.call(any()))
//             .thenAnswer((_) async => Left(ServerFailure('Registration failed')));
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc.add(RegisterUserEvent()),
//       expect: () => [
//         AuthenticateLoading(),
//         AuthenticateError('Registration failed'),
//       ],
//     );

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'emits [AuthenticateLoading, AuthenticateSuccess] on successful login',
//       build: () {
//         when(() => mockLoginUser.call(any()))
//             .thenAnswer((_) async => Right(true));
//         when(() => mockPreferences.setString(any(), any()))
//             .thenAnswer((_) async => true);
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc.add(LoginUserEvent(userId: 'user_1')),
//       expect: () => [
//         AuthenticateLoading(),
//         AuthenticateSuccess(userId: 'user_1'),
//       ],
//       verify: (_) {
//         verify(() => mockPreferences.setString('userId', 'user_1')).called(1);
//       },
//     );

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'emits [AuthenticateLoading, AuthenticateError] on invalid login',
//       build: () {
//         when(() => mockLoginUser.call(any()))
//             .thenAnswer((_) async => Right(false));
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc.add(LoginUserEvent(userId: 'user_1')),
//       expect: () => [
//         AuthenticateLoading(),
//         AuthenticateError('Invalid User ID'),
//       ],
//     );

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'emits [AuthenticateLoading, AuthenticateError] on login failure',
//       build: () {
//         when(() => mockLoginUser.call(any()))
//             .thenAnswer((_) async => Left(ServerFailure('Login failed')));
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc.add(LoginUserEvent(userId: 'user_1')),
//       expect: () => [
//         AuthenticateLoading(),
//         AuthenticateError('Login failed'),
//       ],
//     );

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'emits [AuthenticateLoading, Unauthenticated] on successful logout',
//       build: () {
//         when(() => mockLogoutUser.call(any()))
//             .thenAnswer((_) async => const Right(null));
//         when(() => mockPreferences.remove(any()))
//             .thenAnswer((_) async => true);
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc.add(LogoutEvent(mockTaskBloc)),
//       expect: () => [
//         AuthenticateLoading(),
//         Unauthenticated(),
//       ],
//       verify: (_) {
//         verify(() => mockPreferences.remove('userId')).called(1);
//         verify(() => mockTaskBloc.add(const LoadTasksEvent(''))).called(1);
//       },
//     );

//     blocTest<AuthenticateBloc, AuthenticateState>(
//       'emits [AuthenticateLoading, AuthenticateError] on logout failure',
//       build: () {
//         when(() => mockLogoutUser.call(any()))
//             .thenAnswer((_) async => Left(ServerFailure('Logout failed')));
//         return authenticateBloc;
//       },
//       act: (bloc) => bloc.add(LogoutEvent(mockTaskBloc)),
//       expect: () => [
//         AuthenticateLoading(),
//         AuthenticateError('Logout failed'),
//       ],
//     );
//   });
// }
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_firebase/core/usecases/usecase.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/register_user.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/login_user.dart';
import 'package:task_manager_firebase/features/authenticate/domain/usecases/logout_user.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart' as auth;
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart' as task;

class MockRegisterUser extends Mock implements RegisterUser {}

class MockLoginUser extends Mock implements LoginUser {}

class MockLogoutUser extends Mock implements LogoutUser {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockTaskBloc extends Mock implements TaskBloc {}

class FakeTaskEvent extends Fake implements task.TaskEvent {}

void main() {
  late MockRegisterUser mockRegisterUser;
  late MockLoginUser mockLoginUser;
  late MockLogoutUser mockLogoutUser;
  late MockSharedPreferences mockPreferences;
  late MockTaskBloc mockTaskBloc;
  late auth.AuthenticateBloc authenticateBloc;

  setUpAll(() {
    // Register fallback value for TaskEvent
    registerFallbackValue(FakeTaskEvent());
  });

  setUp(() {
    mockRegisterUser = MockRegisterUser();
    mockLoginUser = MockLoginUser();
    mockLogoutUser = MockLogoutUser();
    mockPreferences = MockSharedPreferences();
    mockTaskBloc = MockTaskBloc();

    authenticateBloc = auth.AuthenticateBloc(
      registerUser: mockRegisterUser,
      loginUser: mockLoginUser,
      logoutUser: mockLogoutUser,
      preferences: mockPreferences,
    );

    // Mock TaskBloc stream
    when(() => mockTaskBloc.stream).thenAnswer((_) => Stream.empty());

    // Mock add method for TaskBloc
    when(() => mockTaskBloc.add(any())).thenReturn(null);

    registerFallbackValue(NoParams());
  });

  tearDown(() {
    authenticateBloc.close();
  });

  group('AuthenticateBloc', () {
    testWidgets('emits [AuthenticateLoading, Unauthenticated] on successful logout', (tester) async {
      when(() => mockLogoutUser.call(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockPreferences.remove(any()))
          .thenAnswer((_) async => true);

      // Provide the TaskBloc in the widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: Builder(
              builder: (context) {
                authenticateBloc.add(auth.LogoutEvent(context));
                return const SizedBox(); // Placeholder widget
              },
            ),
          ),
        ),
      );

      // Allow Bloc to process events
      await tester.pumpAndSettle();

      // Verify final state
      expect(authenticateBloc.state, auth.Unauthenticated());

      // Verify interactions with dependencies
      verify(() => mockPreferences.remove('userId')).called(1);
      verify(() => mockTaskBloc.add(const task.LoadTasksEvent(''))).called(1);
    });
  });
}
