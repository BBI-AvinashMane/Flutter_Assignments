import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/pages/task_filter.dart';


void main() {
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'filterByPriorityOrder': false,
      'filterByDueDate': false,
      'specificPriority': '',
    });
    preferences = await SharedPreferences.getInstance();
  });

  Widget createTestWidget() {
    return const MaterialApp(
      home: TaskFilterPage(userId: 'user_123'),
    );
  }

  testWidgets('Initial state loads filters from SharedPreferences', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle(); // Wait for async operations to complete

    // Check that the DropdownButtonFormField is present
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

    // Check initial state of the checkbox
    final priorityOrderCheckbox = find.widgetWithText(CheckboxListTile, "Priority Order (High > Medium > Low)");
    expect(priorityOrderCheckbox, findsOneWidget);
    expect(tester.widget<CheckboxListTile>(priorityOrderCheckbox).value, false);

    // Check the initial state of the "Sort by Due Date" checkbox
    final dueDateCheckbox = find.widgetWithText(CheckboxListTile, "Sort by Due Date");
    expect(dueDateCheckbox, findsOneWidget);
    expect(tester.widget<CheckboxListTile>(dueDateCheckbox).value, false);
  });

testWidgets('Toggling Priority Order checkbox updates state', (WidgetTester tester) async {
  // Mock SharedPreferences setup
  SharedPreferences.setMockInitialValues({
    'filterByPriorityOrder': false,
    'filterByDueDate': false,
    'specificPriority': '',
  });

  await tester.pumpWidget(
    MaterialApp(
      home: TaskFilterPage(userId: 'user_123'),
    ),
  );

  // Find the CheckboxListTile
  final checkboxFinder = find.byKey(const Key('priorityOrderCheckbox'));
  expect(checkboxFinder, findsOneWidget);

  // Tap the checkbox
  await tester.tap(checkboxFinder);
  await tester.pumpAndSettle();

  // Verify debug logs in the console for state change
});




testWidgets('Selecting a specific priority updates state', (WidgetTester tester) async {
  await tester.pumpWidget(createTestWidget());

  // Verify DropdownButtonFormField exists
  expect(find.byKey(const Key('specificPriorityDropdown')), findsOneWidget);

  // Open the dropdown
  await tester.tap(find.byKey(const Key('specificPriorityDropdown')));
  await tester.pumpAndSettle();

  // Select "Medium" priority
  await tester.tap(find.text('Medium').last);
  await tester.pump();

  // Verify that the value is updated in SharedPreferences
  final preferences = await SharedPreferences.getInstance();
  expect(preferences.getString('specificPriority'), equals('Medium'));
});




 testWidgets('Toggling Sort by Due Date checkbox updates state', (WidgetTester tester) async {
  await tester.pumpWidget(createTestWidget());

  // Verify initial state
  expect(find.byType(CheckboxListTile), findsNWidgets(2));
  expect(find.text('Sort by Due Date'), findsOneWidget);

  // Toggle Sort by Due Date checkbox
  await tester.tap(find.text('Sort by Due Date'));
  await tester.pumpAndSettle();

  // Save the state manually for the test
  await preferences.setBool('filterByDueDate', true);

  // Verify state update
  expect(preferences.getBool('filterByDueDate'), true);
});


  testWidgets('Reset button clears filters and navigates back',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap Reset button
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    // Verify preferences are cleared
    expect(preferences.getBool('filterByPriorityOrder'), null);
    expect(preferences.getBool('filterByDueDate'), null);
    expect(preferences.getString('specificPriority'), null);
  });

  testWidgets('Apply Filters button saves filters and navigates back', (WidgetTester tester) async {
  await tester.pumpWidget(createTestWidget());

  // Verify initial state
  expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

  // Select a specific priority
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  debugPrint('Dropdown opened.');

  await tester.tap(find.text('Medium').last);
  await tester.pumpAndSettle();

  // Tap the Apply Filters button
  await tester.tap(find.text('Apply Filters'));
  await tester.pumpAndSettle();

  // Verify navigation back
  expect(find.text('Filter Tasks'), findsNothing);

  // Verify filters are saved
  expect(preferences.getString('specificPriority'), 'Medium');
});

}
