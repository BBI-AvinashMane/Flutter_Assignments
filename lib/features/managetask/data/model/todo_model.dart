class ToDoModel {
  final String id; // Unique identifier
  final String title; // Task title
  final String description; // Task description
  final bool isCompleted; // Completion status

  // Constructor
  const ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  // Factory method to create an instance of ToDoModel from JSON
  factory ToDoModel.fromJson(Map<String, dynamic> json) {
    return ToDoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  // Method to convert a ToDoModel instance to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  // Method to convert ToDoModel to an entity
  ToDoModel toEntity() {
    return ToDoModel(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }

  // Static method to create a ToDoModel from an entity
  static ToDoModel fromEntity(ToDoModel entity) {
    return ToDoModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
    );
  }
}
