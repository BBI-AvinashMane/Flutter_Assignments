import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_state.dart';
import '../widgets/menu_drawer.dart';

class TaskList extends StatefulWidget {
  final String userId;

  const TaskList({required this.userId, Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  String? _selectedTaskId;
  bool _filterByPriority = false;
  bool _filterByDueDate = false;
  String? _selectedPriorityLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      drawer: MenuDrawer(userId: widget.userId),
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
                final isExpanded = _selectedTaskId == task.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTaskId = isExpanded ? null : task.id;
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Due: ${task.dueDate.toLocal()}"),
                          leading: _buildPriorityIndicator(task.priority),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.pushNamed(
                                  context,
                                  '/task_form',
                                  arguments: {
                                    'userId': widget.userId,
                                    'task': task,
                                  },
                                );
                              } else if (value == 'delete') {
                                BlocProvider.of<TaskBloc>(context).add(
                                  DeleteTaskEvent(task.id, widget.userId),
                                );
                              }
                            },
                          ),
                        ),
                        if (isExpanded) _buildTaskDetails(task),
                      ],
                    ),
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
          Navigator.pushNamed(context, '/task_form', arguments: {'userId': widget.userId});
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    Color priorityColor;
    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      case 'low':
      default:
        priorityColor = Colors.green;
        break;
    }
    return CircleAvatar(
      backgroundColor: priorityColor,
      radius: 5,
    );
  }

  Widget _buildTaskDetails(task) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            "Title: ${task.title}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Description: ${task.description ?? 'No description provided'}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Priority: ${task.priority}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Due Date: ${task.dueDate.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Task ID: ${task.id}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            "User ID: ${task.userId}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Filter and Sort Tasks"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text("Filter by Priority"),
              value: _filterByPriority,
              onChanged: (value) {
                setState(() {
                  _filterByPriority = value ?? false;
                  if (!_filterByPriority) _selectedPriorityLevel = null; // Reset priority level
                });
              },
            ),
            if (_filterByPriority)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Priority Level"),
                value: _selectedPriorityLevel,
                onChanged: (value) {
                  setState(() {
                    _selectedPriorityLevel = value;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "High", child: Text("High")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Low", child: Text("Low")),
                ],
              ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text("Sort by Due Date"),
              value: _filterByDueDate,
              onChanged: (value) {
                setState(() {
                  _filterByDueDate = value ?? false;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Apply the filters and sorting
              BlocProvider.of<TaskBloc>(context).add(ApplyFilterEvent(
                filterByPriority: _filterByPriority,
                priorityLevel: _selectedPriorityLevel,
                filterByDueDate: _filterByDueDate,
              ));
              Navigator.pop(context);
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}
