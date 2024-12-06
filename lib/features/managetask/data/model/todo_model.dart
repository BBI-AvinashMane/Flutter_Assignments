class ToDoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  const ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  // Create a ToDoModel from JSON
  factory ToDoModel.fromJson(Map<String, dynamic> json) {
    return ToDoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  // Convert ToDoModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
