import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id; // Unique ID for the task
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority; // High, Medium, Low
  final String userId; // For associating the task with a user

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, title, description, dueDate, priority, userId];
}
