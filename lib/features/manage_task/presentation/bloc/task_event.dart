// abstract class TaskEvent {}

// class LoadTasksEvent extends TaskEvent {
//   final String userId;
//   LoadTasksEvent(this.userId);
// }

// class ApplyFilterEvent extends TaskEvent {
//   final bool filterByPriority;
//   final bool filterByDueDate;
//   final String? priorityLevel;

//   ApplyFilterEvent({
//     required this.filterByPriority,
//     required this.filterByDueDate,
//     this.priorityLevel,
//   });
// }
// class DeleteTaskEvent extends TaskEvent {
//   final String taskId;

//    DeleteTaskEvent(this.taskId);

//   @override
//   List<Object?> get props => [taskId];
// }

// class RestoreFiltersEvent extends TaskEvent {} // Restore saved preferences
import 'package:equatable/equatable.dart';

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

class ApplyFilterEvent extends TaskEvent {
  final bool filterByPriority;
  final bool filterByDueDate;
  final String? priorityLevel;

  const ApplyFilterEvent({
    required this.filterByPriority,
    required this.filterByDueDate,
    this.priorityLevel,
  });

  @override
  List<Object?> get props =>
      [filterByPriority, filterByDueDate, priorityLevel];
}

class RestoreFiltersEvent extends TaskEvent {}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final String userId;

  const DeleteTaskEvent({
    required this.taskId,
    required this.userId,
  });

  @override
  List<Object?> get props => [taskId, userId];
}
