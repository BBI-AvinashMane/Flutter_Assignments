import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required String id,
    required String title,
    String? description,
    required DateTime dueDate,
    required String priority,
    required String userId,
  }) : super(
          id: id,
          title: title,
          description: description!,
          dueDate: dueDate,
          priority: priority,
          userId: userId,
        );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'userId': userId,
    };
  }

  factory TaskModel.fromJson(String id, Map<String, dynamic> json) {
    return TaskModel(
      id: id,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String,
      userId: json['userId'] as String,
    );
  }
}
