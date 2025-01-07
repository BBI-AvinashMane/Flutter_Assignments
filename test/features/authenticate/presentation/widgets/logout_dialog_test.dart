import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/widgets/logout_dialog.dart';


void main() {
  testWidgets('showLogoutDialog displays a dialog with correct content and buttons',
      (WidgetTester tester) async {
    bool? logoutConfirmed;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    logoutConfirmed = await showLogoutDialog(context);
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Tap the button to show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify the dialog content using Keys
    expect(find.byKey(const Key('logoutDialogTitle')), findsOneWidget);
    expect(find.byKey(const Key('logoutDialogContent')), findsOneWidget);

    // Verify buttons using Keys
    expect(find.byKey(const Key('cancelButton')), findsOneWidget);
    expect(find.byKey(const Key('logoutButton')), findsOneWidget);

    // Tap the Cancel button
    await tester.tap(find.byKey(const Key('cancelButton')));
    await tester.pumpAndSettle();

    // Verify the dialog is dismissed and returns false
    expect(logoutConfirmed, isFalse);

    // Show the dialog again
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Tap the Logout button
    await tester.tap(find.byKey(const Key('logoutButton')));
    await tester.pumpAndSettle();

    // Verify the dialog is dismissed and returns true
    expect(logoutConfirmed, isTrue);
  });
}
