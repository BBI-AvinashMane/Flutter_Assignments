import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';

class FilterAndSortTasks {
  List<TaskEntity> call({
    required List<TaskEntity> tasks,
    required bool filterByPriority,
    required bool filterByDueDate,
    String? priorityLevel,
  }) {
    List<TaskEntity> filteredTasks = tasks;

    // Filter by priority
    if (filterByPriority && priorityLevel != null) {
      filteredTasks = filteredTasks.where((task) => task.priority == priorityLevel).toList();
    }

    // Sort by due date, then alphabetically
    filteredTasks.sort((a, b) {
      if (filterByDueDate) {
        final dueDateComparison = a.dueDate.compareTo(b.dueDate);
        if (dueDateComparison == 0) {
          return a.title.compareTo(b.title);
        }
        return dueDateComparison;
      } else {
        return a.title.compareTo(b.title);
      }
    });

    return filteredTasks;
  }
}
