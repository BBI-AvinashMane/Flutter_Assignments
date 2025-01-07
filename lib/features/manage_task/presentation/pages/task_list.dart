
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/menu_drawer.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskList extends StatefulWidget {
  final String userId;

  const TaskList({required this.userId, Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  String? _selectedTaskId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent(widget.userId));
    BlocProvider.of<TaskBloc>(context).add(RestoreFiltersEvent());
  }

  Future<void> _applyFilters(BuildContext context) async {
    final filterResult = await Navigator.pushNamed(
      context,
      '/task_filter',
      arguments: {'userId': widget.userId},
    );

    if (filterResult != null && mounted) {
      final filters = filterResult as Map<String, dynamic>;
      BlocProvider.of<TaskBloc>(context).add(
        ApplyAdvancedFilterEvent(
          filterByPriorityOrder: filters['filterByPriorityOrder'] ?? false,
          filterByDueDate: filters['filterByDueDate'] ?? false,
          specificPriority: filters['specificPriority'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(key: const Key('taskListAppBar'),
        title: const Text("Task Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _applyFilters(context),
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isExpanded ? Colors.blue.shade50 : Colors.white,
                      border: task.dueDate.isBefore(DateTime.now())
                          ? Border.all(color: Colors.red, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: task.dueDate.isBefore(DateTime.now())
                          ? [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Due: ${task.dueDate.toLocal().toString().split(' ')[0]}"),
                          leading: _buildPriorityIndicator(task.priority),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/task_form',
                                    arguments: {
                                      'userId': widget.userId,
                                      'task': task,
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  BlocProvider.of<TaskBloc>(context).add(
                                    DeleteTaskEvent(task.id, widget.userId),
                                  );
                                },
                              ),
                            ],
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
         key: const Key('addTaskButton'),
        onPressed: () async {
         final result= await Navigator.pushNamed(
          context, 
          '/task_form', 
          arguments: {'userId': widget.userId}
          );
          if(result == true){
            context.read<TaskBloc>().add(LoadTasksEvent(widget.userId));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return CircleAvatar(backgroundColor: Colors.red, radius: 5);
      case 'medium':
        return CircleAvatar(backgroundColor: Colors.orange, radius: 5);
      case 'low':
      default:
        return CircleAvatar(backgroundColor: Colors.green, radius: 5);
    }
  }

  Widget _buildTaskDetails(task) {
    final overdueHours = DateTime.now().difference(task.dueDate).inHours;
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
          if (task.dueDate.isBefore(DateTime.now()))
            Text(
              "Overdue by: $overdueHours hours",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
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
}
