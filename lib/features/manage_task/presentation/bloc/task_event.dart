import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final String userId;

  const LoadTasksEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;
  final String userId;

  const AddTaskEvent(this.task, this.userId);

  @override
  List<Object?> get props => [task, userId];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  final String userId;

  const UpdateTaskEvent(this.task, this.userId);

  @override
  List<Object?> get props => [task, userId];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final String userId;

  const DeleteTaskEvent(this.taskId, this.userId);

  @override
  List<Object?> get props => [taskId, userId];
}

class ApplyAdvancedFilterEvent extends TaskEvent {
  final bool filterByPriorityOrder;
  final bool filterByDueDate;
  final String? specificPriority;

  const ApplyAdvancedFilterEvent({
    required this.filterByPriorityOrder,
    required this.filterByDueDate,
    this.specificPriority,
  });

  @override
  List<Object?> get props => [
        filterByPriorityOrder,
        filterByDueDate,
        specificPriority,
      ];
}

class RestoreFiltersEvent extends TaskEvent {}
class LogoutEvent extends TaskEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}