import 'package:flutter/material.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';


class TaskDetails extends StatelessWidget {
  final TaskEntity task;

  const TaskDetails({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              "Due Date: ${task.dueDate.toLocal()}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "Description:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            Text(task.description.isNotEmpty
                ? task.description
                : "No description provided."),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Priority:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.priority == "High"
                        ? Colors.red
                        : task.priority == "Medium"
                            ? Colors.yellow
                            : Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                Text(task.priority),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
