import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/delete_task.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/filter_and_sort_task.dart';
import 'package:task_manager_firebase/features/manage_task/domain/usecases/get_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final FilterAndSortTasks filterAndSortTasks;
  final SharedPreferences preferences;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.filterAndSortTasks,
    required this.preferences,
    required this.deleteTask,
  }) : super(TaskLoading()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<ApplyFilterEvent>(_onApplyFilter);
    on<RestoreFiltersEvent>(_onRestoreFilters);
    on<DeleteTaskEvent>(_onDeleteTask);

    // Restore filters on initialization
    add(RestoreFiltersEvent());
  }

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await getTasks.call(event.userId);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) {
        emit(TaskLoaded(
          tasks: tasks,
          filterByPriority: false,
          filterByDueDate: false,
          priorityLevel: null,
        ));
      },
    );
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      emit(TaskLoading());
      final currentState = state as TaskLoaded;
      final result = await deleteTask.call(event.taskId, event.userId);
      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (_) {
          add(LoadTasksEvent(event.userId));
        },
      );
    }
  }

  void _onApplyFilter(ApplyFilterEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;

      final filteredTasks = filterAndSortTasks.call(
        tasks: currentState.tasks,
        filterByPriority: event.filterByPriority,
        filterByDueDate: event.filterByDueDate,
        priorityLevel: event.priorityLevel,
      );

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
        tasks: currentState.tasks,
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
