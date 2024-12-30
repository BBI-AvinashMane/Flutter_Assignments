import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final bool filterByPriority;
  final bool filterByDueDate;
  final String? priorityLevel;

  const TaskLoaded({
    required this.tasks,
    required this.filterByPriority,
    required this.filterByDueDate,
    this.priorityLevel,
  });

  @override
  List<Object?> get props =>
      [tasks, filterByPriority, filterByDueDate, priorityLevel];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
