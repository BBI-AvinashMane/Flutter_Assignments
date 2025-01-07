// import 'package:flutter/material.dart';
// import 'package:task_manager_firebase/core/utils/constants.dart';
// import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';


// class TaskDetails extends StatelessWidget {
//   final TaskEntity task;

//   const TaskDetails({required this.task, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(Constants.taskDetails),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               task.title,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "${Constants.taskDueDateLabel}${task.dueDate.toLocal()}",
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               Constants.taskDescriptionLabel,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(task.description.isNotEmpty
//                 ? task.description
//                 : Constants.noTaskDescriptionProvided),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 const Text(
//                   Constants.taskPriorityLabel,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: task.priority == Constants.priorityHighText
//                         ? Colors.red
//                         : task.priority == Constants.priorityLowText
//                             ? Colors.yellow
//                             : Colors.green,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(task.priority),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
