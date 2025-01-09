import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/core/utils/constant_colors.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
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
      Constants.taskFilterRoute,
      arguments: {Constants.userId: widget.userId},
    );

    if (filterResult != null && mounted) {
      final filters = filterResult as Map<String, dynamic>;
      BlocProvider.of<TaskBloc>(context).add(
        ApplyAdvancedFilterEvent(
          filterByPriorityOrder:
              filters[Constants.filterByPriorityOrder] ?? false,
          filterByDueDate: filters[Constants.filterByDueDate] ?? false,
          specificPriority: filters[Constants.specificPriority],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key(Constants.taskListAppBar),
        title: const Text(Constants.taskManagement),
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
              return const Center(child: Text(Constants.noTasksFoundMessage));
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isExpanded ?  AppColors.expandedTask: AppColors.taskBackgroundColor,
                      border: task.dueDate.isBefore(DateTime.now())
                          ? Border.all(color: AppColors.errorColor, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: task.dueDate.isBefore(DateTime.now())
                          ? [
                              BoxShadow(
                               // color: AppColors.errorColor,
                                color: AppColors.errorColor.withAlpha((0.3 * 255).toInt()),
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
                          subtitle: Text(
                              "${Constants.taskDueDateLabel}${task.dueDate.toLocal().toString().split(' ')[0]}"),
                          leading: _buildPriorityIndicator(task.priority),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: AppColors.editIconColor),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    Constants.taskFormRoute,
                                    arguments: {
                                      Constants.userId: widget.userId,
                                      Constants.task: task,
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
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
            return Center(child: Text("${Constants.error}${state.message}"));
          }
          return const Center(child: Text(Constants.unExpectedState));
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key(Constants.addTaskButton),
        onPressed: () async {
          final result = await Navigator.pushNamed(
              context, Constants.taskFormRoute,
              arguments: {Constants.userId: widget.userId});
          if (result == true) {
            context.read<TaskBloc>().add(LoadTasksEvent(widget.userId));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    switch (priority.toLowerCase()) {
      case Constants.priorityHigh:
        return const CircleAvatar(backgroundColor:AppColors.highPriority, radius: 5);
      case Constants.priorityMedium:
        return const CircleAvatar(backgroundColor:AppColors.mediumPriority, radius: 5);
      case Constants.priorityLow:
      default:
        return const CircleAvatar(backgroundColor: AppColors.lowPriority, radius: 5);
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
            "${Constants.titleList}${task.title}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "${Constants.descriptionList}${task.description?.isNotEmpty == true ? task.description : Constants.noTaskDescriptionProvided}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (task.dueDate.isBefore(DateTime.now()))
            Text(
              "${Constants.overdueByList}$overdueHours ${Constants.hours}",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.overDueHoursText,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            "${Constants.priorityList}${task.priority}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "${Constants.dueDateList}${task.dueDate.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          // Text(
          //   "Task ID: ${task.id}",
          //   style: const TextStyle(fontSize: 16, color: Colors.grey),
          // ),
          // Text(
          //   "User ID: ${task.userId}",
          //   style: const TextStyle(fontSize: 16, color: Colors.grey),
          // ),
        ],
      ),
    );
  }
}
