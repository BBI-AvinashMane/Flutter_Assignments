import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_state.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/pages/task_form.dart';

class FakeTaskEvent extends Fake implements TaskEvent {}

class MockTaskBloc extends Mock implements TaskBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;

  setUpAll(() {
    registerFallbackValue(FakeTaskEvent());
  });

  setUp(() {
    mockTaskBloc = MockTaskBloc();
    when(() => mockTaskBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockTaskBloc.state).thenReturn(TaskLoading());
  });

  Widget createTestWidget({TaskEntity? task}) {
    return MaterialApp(
      home: BlocProvider<TaskBloc>.value(
        value: mockTaskBloc,
        child: TaskForm(
          userId: 'test_user',
          task: task,
        ),
      ),
    );
  }

  group('TaskForm Widget Tests', () {
   testWidgets('Initial state renders correctly for adding a task',
    (WidgetTester tester) async {
  await tester.pumpWidget(createTestWidget());

  // Verify Add Task button using Key
  expect(find.byKey(const Key(Constants.addUpdateTaskButtonKey)), findsOneWidget);

  // Verify TextFields and Dropdown
  expect(find.byKey(const Key(Constants.titleFieldKey)), findsOneWidget);
  expect(find.text(Constants.taskAddButton), findsNWidgets(2));
});


    testWidgets('Initial state renders correctly for editing a task',
        (WidgetTester tester) async {
      final task = TaskEntity(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: DateTime.now(),
        priority: Constants.priorityHighText,
        userId: 'test_user',
      );

      await tester.pumpWidget(createTestWidget(task: task));

      expect(find.text(Constants.taskEditButton), findsOneWidget);
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text(Constants.priorityHighText), findsOneWidget);
    });

    testWidgets('Validation error shows when title is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byKey(const Key(Constants.addUpdateTaskButtonKey)));
      await tester.pump();

      expect(find.text(Constants.taskValidationTitleEmpty), findsOneWidget);
    });

    testWidgets('Shake animation triggers for invalid due date',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter a title in the TextFormField
      await tester.enterText(
          find.byKey(const Key(Constants.titleFieldKey)), 'Test Title');
      await tester.pump();

      // Tap the Add/Update Task button
      await tester.tap(find.byKey(const Key(Constants.addUpdateTaskButtonKey)));
      await tester.pump();

      // Verify the shake animation
      final slideTransition = find.byType(SlideTransition);
      expect(slideTransition, findsOneWidget);
    });

    testWidgets('Dispatches AddTaskEvent for new task',
        (WidgetTester tester) async {
      when(() => mockTaskBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
          find.byKey(const Key(Constants.titleFieldKey)), 'New Task');
      await tester.tap(find.text(Constants.selectDateLabel));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK')); // Select a date
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key(Constants.addUpdateTaskButtonKey)));
      await tester.pump();

      verify(() => mockTaskBloc.add(any(that: isA<AddTaskEvent>()))).called(1);
    });

    testWidgets('Dispatches UpdateTaskEvent for existing task',
        (WidgetTester tester) async {
      final task = TaskEntity(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: DateTime.now(),
        priority: Constants.priorityMediumText,
        userId: 'test_user',
      );

      when(() => mockTaskBloc.add(any())).thenReturn(null);

      await tester.pumpWidget(createTestWidget(task: task));
      await tester.enterText(
          find.byKey(const Key(Constants.titleFieldKey)), 'Updated Task');

      await tester.tap(find.byKey(const Key(Constants.addUpdateTaskButtonKey)));
      await tester.pump();

      verify(() => mockTaskBloc.add(any(that: isA<UpdateTaskEvent>()))).called(1);
    });
  });
}
