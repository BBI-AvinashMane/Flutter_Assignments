import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/pages/task_list.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_state.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';

class MockTaskBloc extends Mock implements TaskBloc {}

class FakeTaskEvent extends Fake implements TaskEvent {}

void main() {
  late MockTaskBloc mockTaskBloc;

  setUpAll(() {
    registerFallbackValue(FakeTaskEvent());
  });

  setUp(() {
    mockTaskBloc = MockTaskBloc();
  });

  Widget createTestWidget({required String userId}) {
    return MaterialApp(
      home: BlocProvider<TaskBloc>.value(
        value: mockTaskBloc,
        child: TaskList(userId: userId),
      ),
      routes: {
        '/task_form': (context) => const Scaffold(body: Text('Task Form')),
        '/task_filter': (context) => const Scaffold(body: Text('Task Filter')),
      },
    );
  }

  group('TaskList Widget Tests', () {
    testWidgets('Initial state renders with loading spinner',
        (WidgetTester tester) async {
      when(() => mockTaskBloc.state).thenReturn(TaskLoading());
      when(() => mockTaskBloc.stream)
          .thenAnswer((_) => Stream.value(TaskLoading()));

      await tester.pumpWidget(createTestWidget(userId: 'user_1'));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Task Management'), findsOneWidget);
    });

    testWidgets('Displays tasks when loaded', (WidgetTester tester) async {
      final tasks = [
        TaskEntity(
          id: '1',
          title: 'Task 1',
          description: 'Description 1',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          priority: 'High',
          userId: 'user_1',
        ),
      ];

      when(() => mockTaskBloc.state).thenReturn(
        TaskLoaded(
          tasks: tasks,
          originalTasks: tasks,
          filterByPriority: false,
          filterByDueDate: false,
        ),
      );
      when(() => mockTaskBloc.stream).thenAnswer(
        (_) => Stream.value(
          TaskLoaded(
            tasks: tasks,
            originalTasks: tasks,
            filterByPriority: false,
            filterByDueDate: false,
          ),
        ),
      );

      await tester.pumpWidget(createTestWidget(userId: 'user_1'));

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task Management'), findsOneWidget);
    });

    testWidgets('Displays no tasks message when task list is empty',
        (WidgetTester tester) async {
      when(() => mockTaskBloc.state).thenReturn(const TaskLoaded(
        tasks: [],
        originalTasks: [],
        filterByPriority: false,
        filterByDueDate: false,
      ));
      when(() => mockTaskBloc.stream)
          .thenAnswer((_) => Stream.value(const TaskLoaded(
                tasks: [],
                originalTasks: [],
                filterByPriority: false,
                filterByDueDate: false,
              )));

      await tester.pumpWidget(createTestWidget(userId: 'user_1'));
      expect(find.text('No tasks available.'), findsOneWidget);
    });


    testWidgets('Triggers task form on floating action button press',
        (WidgetTester tester) async {
      when(() => mockTaskBloc.state).thenReturn(
        const TaskLoaded(
        tasks: [],
        originalTasks: [],
        filterByPriority: false,
        filterByDueDate: false,
      ));
      when(() => mockTaskBloc.stream)
          .thenAnswer((_) => Stream.value(
            const TaskLoaded(
                tasks: [],
                originalTasks: [],
                filterByPriority: false,
                filterByDueDate: false,
              )));

      await tester.pumpWidget(createTestWidget(userId: 'user_1'));
      final fab = find.byKey(const Key('addTaskButton'));
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.text('Task Form'), findsOneWidget);
    });

    testWidgets('Navigates to task filter on filter button press',
        (WidgetTester tester) async {
      when(() => mockTaskBloc.state).thenReturn(
        const TaskLoaded(
          tasks: [],
          originalTasks: [],
          filterByPriority: false,
          filterByDueDate: false,
        ),
      );
       when(() => mockTaskBloc.stream)
          .thenAnswer((_) => Stream.value(
            const TaskLoaded(
                tasks: [],
                originalTasks: [],
                filterByPriority: false,
                filterByDueDate: false,
              )));

      await tester.pumpWidget(createTestWidget(userId: 'user_1'));
      await tester.tap(find.byIcon(Icons.filter_alt));
      await tester.pumpAndSettle();

      expect(find.text('Task Filter'), findsOneWidget);
    });

 testWidgets('Displays error message on TaskError state', (WidgetTester tester) async {
  when(() => mockTaskBloc.state).thenReturn(const TaskError('An error occurred'));
  when(() => mockTaskBloc.stream).thenAnswer((_) => Stream.value(const TaskError('An error occurred')));

  await tester.pumpWidget(createTestWidget(userId: 'user_1'));

  expect(find.text('Error: An error occurred'), findsOneWidget);
});

    testWidgets('Deletes a task on delete button press',
        (WidgetTester tester) async {
      final task = TaskEntity(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: 'High',
        userId: 'user_1',
      );

      when(() => mockTaskBloc.state).thenReturn(
        TaskLoaded(
          tasks: [task],
          originalTasks: [task],
          filterByPriority: false,
          filterByDueDate: false,
        ),
      );
      when(() => mockTaskBloc.stream)
          .thenAnswer((_) => Stream.value(
            const TaskLoaded(
                tasks: [],
                originalTasks: [],
                filterByPriority: false,
                filterByDueDate: false,
              )));

      await tester.pumpWidget(createTestWidget(userId: 'user_1'));
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      verify(() => mockTaskBloc.add(DeleteTaskEvent(task.id, 'user_1')))
          .called(1);
    });
  });
}
