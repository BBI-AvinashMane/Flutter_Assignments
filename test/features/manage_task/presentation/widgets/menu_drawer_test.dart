import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/widgets/menu_drawer.dart';

class MockAuthenticateBloc extends Mock implements AuthenticateBloc {}

class FakeAuthenticateEvent extends Fake implements AuthenticateEvent {}

class FakeAuthenticateState extends Fake implements AuthenticateState {}

void main() {
  late MockAuthenticateBloc mockAuthenticateBloc;
  late StreamController<AuthenticateState> streamController;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticateEvent());
    registerFallbackValue(FakeAuthenticateState());
  });

  setUp(() {
    mockAuthenticateBloc = MockAuthenticateBloc();
    streamController = StreamController<AuthenticateState>();
    when(() => mockAuthenticateBloc.stream).thenAnswer((_) => streamController.stream);
    when(() => mockAuthenticateBloc.state).thenReturn(FakeAuthenticateState());
    when(() => mockAuthenticateBloc.add(any())).thenReturn(null);
  });

  tearDown(() {
    streamController.close();
  });

  Future<void> _buildTestWidget(WidgetTester tester, {required String userId}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test App')),
          drawer: BlocProvider<AuthenticateBloc>.value(
            value: mockAuthenticateBloc,
            child: MenuDrawer(userId: userId),
          ),
        ),
      ),
    );
  }

  group('MenuDrawer Widget Tests', () {
    testWidgets('Displays correct user ID in drawer header', (WidgetTester tester) async {
      const userId = 'user_123';

      await _buildTestWidget(tester, userId: userId);

      // Open the drawer
      await tester.tap(find.byTooltip('Open navigation menu')); // Ensure drawer opens
      await tester.pumpAndSettle();

      // Verify drawer header contents
      expect(find.text('Welcome'), findsOneWidget); // Verify "Welcome" text exists
      expect(find.text(userId), findsOneWidget); // Verify full userId
      expect(find.text('123'), findsOneWidget); // Verify extracted user number
    });

    testWidgets('Shows logout dialog when tapping Logout', (WidgetTester tester) async {
      const userId = 'user_123';

      await _buildTestWidget(tester, userId: userId);

      // Open the drawer
      await tester.tap(find.byTooltip('Open navigation menu')); // Ensure drawer opens
      await tester.pumpAndSettle();

      // Tap the Logout menu item
      final logoutTile = find.widgetWithText(ListTile, 'Logout');
      expect(logoutTile, findsOneWidget); // Verify Logout tile exists
      await tester.tap(logoutTile);
      await tester.pumpAndSettle();

      // Verify the dialog appears
      expect(find.text('Confirm Logout'), findsOneWidget);
      expect(find.text('Are you sure you want to log out?'), findsOneWidget);
    });

    testWidgets('Cancels logout when Cancel is tapped', (WidgetTester tester) async {
      const userId = 'user_123';

      await _buildTestWidget(tester, userId: userId);

      // Open the drawer
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      // Tap the Logout menu item
      final logoutTile = find.widgetWithText(ListTile, 'Logout');
      expect(logoutTile, findsOneWidget); // Verify Logout tile exists
      await tester.tap(logoutTile);
      await tester.pumpAndSettle();

      // Verify the dialog appears
      expect(find.text('Confirm Logout'), findsOneWidget);

      // Tap Cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed
      expect(find.text('Confirm Logout'), findsNothing);

      // Ensure LogoutEvent is not triggered
      verifyNever(() => mockAuthenticateBloc.add(any()));
    });

    testWidgets('Proceeds with logout when Logout is confirmed', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'filterByPriority': true,
        'priorityLevel': 'High',
        'filterByDueDate': true,
        'userId': 'user_123',
      });

      const userId = 'user_123';

      await _buildTestWidget(tester, userId: userId);

      // Open the drawer
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      // Tap the Logout menu item
      final logoutTile = find.widgetWithText(ListTile, 'Logout');
      expect(logoutTile, findsOneWidget); // Verify Logout tile exists
      await tester.tap(logoutTile);
      await tester.pumpAndSettle();

      // Verify the dialog appears
      expect(find.text('Confirm Logout'), findsOneWidget);
      expect(find.text('Are you sure you want to log out?'), findsOneWidget);

      // Tap the Logout button in the dialog
      final dialogLogoutButton = find.widgetWithText(ElevatedButton, 'Logout');
      expect(dialogLogoutButton, findsOneWidget); // Verify Logout button exists
      await tester.tap(dialogLogoutButton);
      await tester.pumpAndSettle();

      // Verify shared preferences are cleared
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getKeys(), isEmpty);

      // Verify LogoutEvent is triggered
      verify(() => mockAuthenticateBloc.add(any(that: isA<LogoutEvent>()))).called(1);

      // Verify navigation happens
      expect(find.byType(MenuDrawer), findsNothing); // MenuDrawer is replaced
    });
  });
}
