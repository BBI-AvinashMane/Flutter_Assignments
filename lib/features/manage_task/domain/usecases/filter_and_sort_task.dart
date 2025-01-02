
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';

class FilterAndSortTasks {
  /// Filters and sorts a list of tasks based on the provided criteria.
  List<TaskEntity> call({
    required List<TaskEntity> tasks,
    bool filterByPriority = false,
    bool filterByDueDate = false,
    bool sortByPriorityOrder = false,
    String? specificPriority,
  }) {
    List<TaskEntity> filteredTasks = List.from(tasks);

    // Ensure specificPriority is ignored if sortByPriorityOrder is true
    if (sortByPriorityOrder && specificPriority != null) {
      throw ArgumentError(
          "Cannot filter by specific priority when 'Priority Order' is selected.");
    }

    // Filter by specific priority
    if (filterByPriority && specificPriority != null) {
      filteredTasks = filteredTasks
          .where((task) => task.priority.toLowerCase() == specificPriority.toLowerCase())
          .toList();
    }

    // Sort by due date and alphabetically
    if (filterByDueDate) {
      filteredTasks.sort((a, b) {
        final dueDateComparison = a.dueDate.compareTo(b.dueDate);
        if (dueDateComparison == 0) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        }
        return dueDateComparison;
      });
    }

    // Sort by priority order (High > Medium > Low)
    if (sortByPriorityOrder) {
      const priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      filteredTasks.sort((a, b) => priorityOrder[a.priority]! - priorityOrder[b.priority]!);
    }

    // Default sort alphabetically if no filters are applied
    if (!filterByPriority && !filterByDueDate && !sortByPriorityOrder) {
      filteredTasks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }

    return filteredTasks;
  }
}
