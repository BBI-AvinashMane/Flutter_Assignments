import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/pages/task_details.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/pages/task_form.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskList extends StatelessWidget {
  final String userId;

  const TaskList({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              // Add a dialog or screen for filter options
              // Dispatch an ApplyFilterEvent with selected filters
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text("No tasks available."));
            }

            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                final priorityColor = task.priority == "High"
                    ? Colors.red
                    : task.priority == "Medium"
                        ? Colors.yellow
                        : Colors.green;

                return Card(
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text("Due: ${task.dueDate.toLocal()}"),
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: priorityColor,
                      ),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskForm(task: task, userId: userId),
                            ),
                          );
                        } else if (value == 'delete') {
                          BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(
                            taskId: task.id,
                            userId: userId,
                          ));
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetails(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("Unexpected state."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskForm(task: null, userId: userId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
