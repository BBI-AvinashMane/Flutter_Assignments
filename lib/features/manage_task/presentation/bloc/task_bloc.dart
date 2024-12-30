import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/filter_and_sort_task.dart';
import '../../domain/usecases/get_task.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final FilterAndSortTasks filterAndSortTasks;
  final SharedPreferences preferences;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.filterAndSortTasks,
    required this.preferences,
  }) : super(TaskLoading()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ApplyFilterEvent>(_onApplyFilter);
    on<RestoreFiltersEvent>(_onRestoreFilters);

    // Restore saved filters on initialization
    add(RestoreFiltersEvent());
  }

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await getTasks.call(event.userId);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(
        tasks: tasks,
        filterByPriority: false,
        filterByDueDate: false,
        priorityLevel: null,
      )),
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await addTask.call(AddTaskParams(event.task, event.userId));
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => add(LoadTasksEvent(event.userId)),
    );
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result =
        await updateTask.call(UpdateTaskParams(event.task, event.userId));
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => add(LoadTasksEvent(event.userId)),
    );
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result =
        await deleteTask.call(DeleteTaskParams(event.taskId, event.userId));
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (_) => add(LoadTasksEvent(event.userId)),
    );
  }

  void _onApplyFilter(ApplyFilterEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final filteredTasks = filterAndSortTasks.call(
        currentState.tasks,
        filterByPriority: event.filterByPriority,
        filterByDueDate: event.filterByDueDate,
        priorityLevel: event.priorityLevel,
      );

      // Save filters to preferences
      preferences.setBool('filterByPriority', event.filterByPriority);
      preferences.setBool('filterByDueDate', event.filterByDueDate);
      if (event.priorityLevel != null) {
        preferences.setString('priorityLevel', event.priorityLevel!);
      }

      emit(TaskLoaded(
        tasks: filteredTasks,
        filterByPriority: event.filterByPriority,
        filterByDueDate: event.filterByDueDate,
        priorityLevel: event.priorityLevel,
      ));
    }
  }

  void _onRestoreFilters(RestoreFiltersEvent event, Emitter<TaskState> emit) {
    final filterByPriority = preferences.getBool('filterByPriority') ?? false;
    final filterByDueDate = preferences.getBool('filterByDueDate') ?? false;
    final priorityLevel = preferences.getString('priorityLevel');

    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final filteredTasks = filterAndSortTasks.call(
        currentState.tasks,
        filterByPriority: filterByPriority,
        filterByDueDate: filterByDueDate,
        priorityLevel: priorityLevel,
      );

      emit(TaskLoaded(
        tasks: filteredTasks,
        filterByPriority: filterByPriority,
        filterByDueDate: filterByDueDate,
        priorityLevel: priorityLevel,
      ));
    }
  }
}
