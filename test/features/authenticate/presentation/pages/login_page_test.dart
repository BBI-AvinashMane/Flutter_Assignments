import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/pages/login_page.dart';

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
    when(() => mockAuthenticateBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthenticateBloc.state).thenReturn(AuthenticateInitial());
    when(() => mockAuthenticateBloc.close()).thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    mockAuthenticateBloc.close();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<AuthenticateBloc>.value(
        value: mockAuthenticateBloc,
        child: const LoginPage(),
      ),
      routes: {
        '/tasks': (context) => const Scaffold(body: Text('Tasks Page')),
      },
    );
  }

  group('LoginPage Tests', () {
    testWidgets('Initial state displays User ID field and Login button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify AppBar title using its Key
      expect(find.byKey(const Key('appBarLoginTitle')), findsOneWidget);

      // Verify TextFormField using its Key
      expect(find.byKey(const Key('userIdTextField')), findsOneWidget);

      // Verify ElevatedButton using its Key
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
    });

    testWidgets('Shows error when User ID is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      // Verify error message is displayed
      expect(find.text('User ID cannot be empty'), findsOneWidget);
    });

    testWidgets('Displays CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      when(() => mockAuthenticateBloc.state).thenReturn(AuthenticateLoading());

      await tester.pumpWidget(createTestWidget());

      // Verify CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify Login button is not displayed
      expect(find.byKey(const Key('loginButton')), findsNothing);
    });

    testWidgets('Navigates to /tasks on successful login',
    (WidgetTester tester) async {
  whenListen(
    mockAuthenticateBloc,
    Stream.fromIterable([AuthenticateSuccess(userId: 'user_123')]),
    initialState: AuthenticateInitial(),
  );

  await tester.pumpWidget(createTestWidget());
  await tester.enterText(find.byKey(const Key('userIdTextField')), 'user_123');
  await tester.tap(find.byKey(const Key('loginButton')));
  await tester.pumpAndSettle();

  // Verify navigation to Tasks Page
  expect(find.text('Tasks Page'), findsOneWidget);
});

testWidgets('Shows SnackBar on login error', (WidgetTester tester) async {
  whenListen(
    mockAuthenticateBloc,
    Stream.fromIterable([AuthenticateError('Invalid User ID')]),
    initialState: AuthenticateInitial(),
  );

  await tester.pumpWidget(createTestWidget());
  await tester.enterText(find.byKey(const Key('userIdTextField')), 'user_invalid');
  await tester.tap(find.byKey(const Key('loginButton')));
  await tester.pump(); // Allow SnackBar to appear

  // Verify SnackBar and error message
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Invalid User ID'), findsOneWidget);
});

  });
}
