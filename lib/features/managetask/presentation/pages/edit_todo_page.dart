import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';


class EditTodoPage extends StatelessWidget {
  final ToDoModel todo;

  EditTodoPage({super.key, required this.todo});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize the text controllers with existing task values
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedTitle = _titleController.text.trim();
                final updatedDescription = _descriptionController.text.trim();

                if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                  // Dispatch the edit event
                  BlocProvider.of<ToDoBloc>(context).add(
                    EditToDoEvent(
                      id: todo.id,
                      title: updatedTitle,
                      description: updatedDescription,
                      isCompleted: todo.isCompleted,
                    ),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task updated successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and Description cannot be empty'),
                    ),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
