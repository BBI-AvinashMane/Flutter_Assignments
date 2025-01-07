import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/pages/authenticate_page.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart';

class MockAuthenticateBloc extends Mock implements AuthenticateBloc {}

class FakeAuthenticateState extends Fake implements AuthenticateState {}

class FakeAuthenticateEvent extends Fake implements AuthenticateEvent {}

void main() {
  late MockAuthenticateBloc mockAuthenticateBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticateState());
    registerFallbackValue(FakeAuthenticateEvent());
  });

  setUp(() {
    mockAuthenticateBloc = MockAuthenticateBloc();

    // Mock stream and close
    when(() => mockAuthenticateBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthenticateBloc.close()).thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    mockAuthenticateBloc.close();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<AuthenticateBloc>.value(
        value: mockAuthenticateBloc,
        child: const AuthenticatePage(),
      ),
      routes: {
        '/login': (context) => const Scaffold(body: Text('Login Page')),
        '/tasks': (context) => const Scaffold(body: Text('Tasks Page')),
      },
    );
  }

  testWidgets('Initial state displays Register and Login buttons', (WidgetTester tester) async {
    when(() => mockAuthenticateBloc.state).thenReturn(AuthenticateInitial());

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('State: AuthenticateLoading shows CircularProgressIndicator', (WidgetTester tester) async {
    when(() => mockAuthenticateBloc.state).thenReturn(AuthenticateLoading());

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('State: AuthenticateError shows SnackBar', (WidgetTester tester) async {
    whenListen(
      mockAuthenticateBloc,
      Stream.fromIterable([AuthenticateError('Error occurred')]),
      initialState: AuthenticateInitial(),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pump(); // Trigger the SnackBar animation

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Error occurred'), findsOneWidget);
  });

  testWidgets('State: AuthenticateSuccess navigates to /tasks', (WidgetTester tester) async {
    whenListen(
      mockAuthenticateBloc,
      Stream.fromIterable([AuthenticateSuccess(userId: 'user_1')]),
      initialState: AuthenticateInitial(),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle(); // Wait for navigation

    expect(find.text('Tasks Page'), findsOneWidget);
  });

testWidgets('Tapping Register button triggers RegisterUserEvent', (WidgetTester tester) async {
  // Set the initial state of the AuthenticateBloc
  when(() => mockAuthenticateBloc.state).thenReturn(AuthenticateInitial());
  when(() => mockAuthenticateBloc.add(any())).thenReturn(null); // Mock the `add` method

  // Build the widget
  await tester.pumpWidget(createTestWidget());

  // Simulate a tap on the "Register" button
  await tester.tap(find.text('Register'));
  await tester.pump(); // Process the tap event

  // Verify that the `RegisterUserEvent` was added to the bloc
  verify(() => mockAuthenticateBloc.add(any(that: isA<RegisterUserEvent>()))).called(1);
});

  testWidgets('Tapping Login button navigates to /login', (WidgetTester tester) async {
    when(() => mockAuthenticateBloc.state).thenReturn(AuthenticateInitial());

    await tester.pumpWidget(createTestWidget());
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); // Wait for navigation

    expect(find.text('Login Page'), findsOneWidget);
  });
}
