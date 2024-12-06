abstract class ToDoEvent {}

class LoadToDos extends ToDoEvent {}

class AddToDoEvent extends ToDoEvent {
  final String title;
  final String description;

  AddToDoEvent({required this.title, required this.description});
}

class EditToDoEvent extends ToDoEvent {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  EditToDoEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}

class DeleteToDoEvent extends ToDoEvent {
  final String id;

  DeleteToDoEvent({required this.id});
}
