// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
// import '../bloc/todo_bloc.dart';



// class EditTodoPage extends StatelessWidget {
//   final ToDoModel todo;

//   EditTodoPage({super.key, required this.todo});

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // Initialize the text controllers with existing task values
//     _titleController.text = todo.title;
//     _descriptionController.text = todo.description;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Task'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Task Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Task Description',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final updatedTitle = _titleController.text.trim();
//                 final updatedDescription = _descriptionController.text.trim();

//                 if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
//                   // Dispatch the edit event
//                   BlocProvider.of<ToDoBloc>(context).add(
//                     EditToDoEvent(
//                       id: todo.id,
//                       title: updatedTitle,
//                       description: updatedDescription,
//                       isCompleted: todo.isCompleted,
//                     ),
//                   );
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Task updated successfully')),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Title and Description cannot be empty'),
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_using_bloc/features/managetask/data/model/todo_model.dart';
import '../bloc/todo_bloc.dart';

class EditTodoPage extends StatefulWidget {
  final ToDoModel todo;

  const EditTodoPage({super.key, required this.todo});

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with existing task values
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
  }

  @override
  void dispose() {
    // Dispose of the controllers to free resources
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges(BuildContext context) {
    final updatedTitle = _titleController.text.trim();
    final updatedDescription = _descriptionController.text.trim();

    if (updatedTitle.isEmpty || updatedDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and Description cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Dispatch the edit event
    context.read<ToDoBloc>().add(
          EditToDoEvent(
            id: widget.todo.id,
            title: updatedTitle,
            description: updatedDescription,
            isCompleted: widget.todo.isCompleted,
          ),
        );

    Navigator.pop(context);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Task updated successfully'),
    //     backgroundColor: Colors.green,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveChanges(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task update canceled'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
