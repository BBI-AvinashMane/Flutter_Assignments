// import 'package:clean_to_do_app/features/managetask/data/model/todo_model.dart';
// import 'package:clean_to_do_app/features/managetask/presentation/providers/todo_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// class ToDoPage extends StatelessWidget {
//   const ToDoPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ToDoProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('To-Do List'),
//         centerTitle: true,
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.todoList.isEmpty
//               ? const Center(
//                   child: Text(
//                     'No tasks available. Add a new task!',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: provider.todoList.length,
//                   itemBuilder: (context, index) {
//                     final todo = provider.todoList[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 16),
//                       child: ListTile(
//                         leading: Checkbox(
//                           value: todo.isCompleted,
//                           onChanged: (value) {
//                             final updatedToDo = ToDoModel(
//                               id: todo.id,
//                               title: todo.title,
//                               description: todo.description,
//                               isCompleted: value!,
//                             );
//                             provider.editTask(updatedToDo);
//                           },
//                         ),
//                         title: Text(
//                           todo.title,
//                           style: TextStyle(
//                             decoration: todo.isCompleted
//                                 ? TextDecoration.lineThrough
//                                 : TextDecoration.none,
//                           ),
//                         ),
//                         subtitle: Text(todo.description),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () {
//                                 _showEditTaskDialog(context, provider, todo);
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 provider.deleteTask(todo.id);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Task deleted'),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddTaskDialog(context, provider);
//         },
//         tooltip: 'Add Task',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddTaskDialog(BuildContext context, ToDoProvider provider) {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add Task'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Task Title',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Task Description',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 final title = titleController.text.trim();
//                 final description = descriptionController.text.trim();

//                 if (title.isNotEmpty && description.isNotEmpty) {
//                   final todo = ToDoModel(
//                     id: DateTime.now().millisecondsSinceEpoch.toString(),
//                     title: title,
//                     description: description,
//                   );
//                   provider.addTask(todo);
//                   Navigator.of(context).pop();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Task added')),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Title and Description cannot be empty'),
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Add'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showEditTaskDialog(
//       BuildContext context, ToDoProvider provider, ToDoModel todo) {
//     final titleController = TextEditingController(text: todo.title);
//     final descriptionController =
//         TextEditingController(text: todo.description);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Task'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Task Title',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Task Description',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 final updatedTitle = titleController.text.trim();
//                 final updatedDescription = descriptionController.text.trim();

//                 if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
//                   final updatedToDo = ToDoModel(
//                     id: todo.id,
//                     title: updatedTitle,
//                     description: updatedDescription,
//                     isCompleted: todo.isCompleted,
//                   );
//                   provider.editTask(updatedToDo);
//                   Navigator.of(context).pop();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Task updated')),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Title and Description cannot be empty'),
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Save'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:clean_to_do_app/features/managetask/data/model/todo_model.dart';
import 'package:clean_to_do_app/features/managetask/presentation/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_todo_page.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToDoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.todoList.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks available. Add a new task!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: provider.todoList.length,
                  itemBuilder: (context, index) {
                    final todo = provider.todoList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (value) {
                            final updatedToDo = ToDoModel(
                              id: todo.id,
                              title: todo.title,
                              description: todo.description,
                              isCompleted: value!,
                            );
                            provider.editTask(updatedToDo);
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(todo.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditTodoPage(todo: todo),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, provider, todo.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, provider);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ToDoProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.deleteTask(id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task deleted successfully')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context, ToDoProvider provider) {
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
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  final todo = ToDoModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    description: description,
                  );
                  provider.addTask(todo);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task added successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fields cannot be empty')),
                  );
                }
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

