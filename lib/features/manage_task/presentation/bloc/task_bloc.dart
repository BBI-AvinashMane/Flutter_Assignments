
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
    on<ApplyAdvancedFilterEvent>(_onApplyFilter);
    on<RestoreFiltersEvent>(_onRestoreFilters);
    on<LogoutEvent>(_onLogout);

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
        originalTasks: tasks,
        filterByPriority: false,
        filterByDueDate: false,
        priorityLevel: null,
      )),
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(TaskLoading());
      final result = await addTask.call(AddTaskParams(event.task, event.userId));
      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (_) {
          add(LoadTasksEvent(event.userId));
          emit(TaskLoaded(
            tasks: filterAndSortTasks.call(
              tasks: currentState.originalTasks..add(event.task),
              filterByPriority: currentState.filterByPriority,
              filterByDueDate: currentState.filterByDueDate,
              specificPriority: currentState.priorityLevel,
            ),
            originalTasks: currentState.originalTasks..add(event.task),
            filterByPriority: currentState.filterByPriority,
            filterByDueDate: currentState.filterByDueDate,
            priorityLevel: currentState.priorityLevel,
          ));
        },
      );
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(TaskLoading());
      final result = await updateTask.call(UpdateTaskParams(event.task, event.userId));
      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (_) {
          final updatedTasks = currentState.originalTasks
              .map((task) => task.id == event.task.id ? event.task : task)
              .toList();
          emit(TaskLoaded(
            tasks: filterAndSortTasks.call(
              tasks: updatedTasks,
              filterByPriority: currentState.filterByPriority,
              filterByDueDate: currentState.filterByDueDate,
              specificPriority: currentState.priorityLevel,
            ),
            originalTasks: updatedTasks,
            filterByPriority: currentState.filterByPriority,
            filterByDueDate: currentState.filterByDueDate,
            priorityLevel: currentState.priorityLevel,
          ));
        },
      );
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(TaskLoading());
      final result = await deleteTask.call(DeleteTaskParams(event.taskId, event.userId));
      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (_) {
          final updatedTasks = currentState.originalTasks
              .where((task) => task.id != event.taskId)
              .toList();
          emit(TaskLoaded(
            tasks: filterAndSortTasks.call(
              tasks: updatedTasks,
              filterByPriority: currentState.filterByPriority,
              filterByDueDate: currentState.filterByDueDate,
              specificPriority: currentState.priorityLevel,
            ),
            originalTasks: updatedTasks,
            filterByPriority: currentState.filterByPriority,
            filterByDueDate: currentState.filterByDueDate,
            priorityLevel: currentState.priorityLevel,
          ));
        },
      );
    }
  }

  void _onApplyFilter(ApplyAdvancedFilterEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      // Save filters to shared preferences
      preferences.setBool('filterByPriority', event.specificPriority != null);
      preferences.setString('priorityLevel', event.specificPriority ?? '');
      preferences.setBool('filterByDueDate', event.filterByDueDate);

      final filteredTasks = filterAndSortTasks.call(
        tasks: currentState.originalTasks,
        filterByPriority: event.specificPriority != null,
        filterByDueDate: event.filterByDueDate,
        sortByPriorityOrder: event.filterByPriorityOrder,
        specificPriority: event.specificPriority,
      );

      emit(TaskLoaded(
        tasks: filteredTasks,
        originalTasks: currentState.originalTasks,
        filterByPriority: event.specificPriority != null,
        filterByDueDate: event.filterByDueDate,
        priorityLevel: event.specificPriority,
      ));
    }
  }

  Future<void> _onRestoreFilters(RestoreFiltersEvent event, Emitter<TaskState> emit) async {
  final userId = preferences.getString('userId') ?? ''; // Retrieve user ID
  if (userId.isEmpty) {
    emit(TaskError("No user ID found. Please log in."));
    return;
  }

  // Load saved filters
  final filterByPriority = preferences.getBool('filterByPriority') ?? false;
  final filterByDueDate = preferences.getBool('filterByDueDate') ?? false;
  final priorityLevel = preferences.getString('priorityLevel');

  final result = await getTasks.call(userId);
  result.fold(
    (failure) => emit(TaskError(failure.message)),
    (tasks) {
      final filteredTasks = filterAndSortTasks.call(
        tasks: tasks,
        filterByPriority: filterByPriority,
        filterByDueDate: filterByDueDate,
        specificPriority: priorityLevel,
      );
      emit(TaskLoaded(
        tasks: filteredTasks,
        originalTasks: tasks,
        filterByPriority: filterByPriority,
        filterByDueDate: filterByDueDate,
        priorityLevel: priorityLevel,
      ));
    },
  );
}


  Future<void> _onLogout(LogoutEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      // Clear shared preferences related to filtering and sorting
      await preferences.remove('filterByPriority');
      await preferences.remove('priorityLevel');
      await preferences.remove('filterByDueDate');
      await preferences.remove('userId');

      emit(TaskLoggedOut());
    } catch (e) {
      emit(TaskError("Failed to log out: ${e.toString()}"));
    }
  }
}
