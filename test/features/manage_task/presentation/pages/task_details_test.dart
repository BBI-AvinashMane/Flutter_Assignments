// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
// import 'package:task_manager_firebase/features/manage_task/presentation/pages/task_details.dart';

// void main() {
//   late TaskEntity task;

//   setUp(() {
//     task = TaskEntity(
//       id: '1', // Added required parameter
//       userId: 'user_123', // Added required parameter
//       title: 'Complete Project',
//       description: 'Finish the project by end of the week.',
//       dueDate: DateTime.now().add(const Duration(days: 1)),
//       priority: 'High',
//     );
//   });

//   Widget createTestWidget(TaskEntity task) {
//     return MaterialApp(
//       home: TaskDetails(task: task),
//     );
//   }

//   testWidgets('Displays task details correctly', (WidgetTester tester) async {
//     await tester.pumpWidget(createTestWidget(task));

//     // Verify title
//     expect(find.text('Complete Project'), findsOneWidget);

//     // Verify due date
//     expect(
//       find.text('Due Date: ${task.dueDate.toLocal()}'),
//       findsOneWidget,
//     );

//     // Verify description
//     expect(find.text('Description:'), findsOneWidget);
//     expect(find.text('Finish the project by end of the week.'), findsOneWidget);

//     // Verify priority label and value
//     expect(find.text('Priority:'), findsOneWidget);
//     expect(find.text('High'), findsOneWidget);

//     // Verify priority circle color
//     final Container priorityIndicator =
//         tester.widget(find.byType(Container).first);
//     expect(priorityIndicator.decoration,
//         const BoxDecoration(shape: BoxShape.circle, color: Colors.red));
//   });

//   testWidgets('Displays "No description provided" when description is empty',
//       (WidgetTester tester) async {
//     final taskWithoutDescription = TaskEntity(
//       id: '2', // Added required parameter
//       userId: 'user_456', // Added required parameter
//       title: 'New Task',
//       description: '',
//       dueDate: DateTime.now().add(const Duration(days: 1)),
//       priority: 'Medium',
//     );

//     await tester.pumpWidget(createTestWidget(taskWithoutDescription));

//     // Verify "No description provided" text
//     expect(find.text('No description provided.'), findsOneWidget);

//     // Verify priority circle color
//     final Container priorityIndicator =
//         tester.widget(find.byType(Container).first);
//     expect(priorityIndicator.decoration,
//         const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow));
//   });

//   testWidgets('Handles low priority task correctly',
//       (WidgetTester tester) async {
//     final lowPriorityTask = TaskEntity(
//       id: '3', // Added required parameter
//       userId: 'user_789', // Added required parameter
//       title: 'Optional Task',
//       description: 'This task is not urgent.',
//       dueDate: DateTime.now().add(const Duration(days: 3)),
//       priority: 'Low',
//     );

//     await tester.pumpWidget(createTestWidget(lowPriorityTask));

//     // Verify priority circle color
//     final Container priorityIndicator =
//         tester.widget(find.byType(Container).first);
//     expect(priorityIndicator.decoration,
//         const BoxDecoration(shape: BoxShape.circle, color: Colors.green));
//   });
// }
