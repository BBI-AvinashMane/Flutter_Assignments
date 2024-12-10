import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_bloc.dart';
import 'edit_todo_page.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  @override
  void initState() {
    super.initState();
    context.read<ToDoBloc>().add(LoadToDos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
      ),
      body: BlocBuilder<ToDoBloc, ToDoState>(
        builder: (context, state) {
          if (state is ToDoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ToDoLoaded) {
            final todos = state.todos;
            return todos.isEmpty
                ? const Center(child: Text('No tasks available. Add a new task!'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.isCompleted,
                            onChanged: (value) {
                              context.read<ToDoBloc>().add(
                                    EditToDoEvent(
                                      id: todo.id,
                                      title: todo.title,
                                      description: todo.description,
                                      isCompleted: value ?? false,
                                    ),
                                  );
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: todo.isCompleted
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  )
                                : const TextStyle(),
                          ),
                          subtitle: Text(
                            todo.description,
                            style: todo.isCompleted
                                ? const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  )
                                : const TextStyle(),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditTodoPage(todo: todo),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, todo.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          } else if (state is ToDoError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No tasks found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<ToDoBloc>().add(
                      AddToDoEvent(
                        title: titleController.text,
                        description: descriptionController.text,
                      ),
                    );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ToDoBloc>().add(DeleteToDoEvent(id: id));
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
