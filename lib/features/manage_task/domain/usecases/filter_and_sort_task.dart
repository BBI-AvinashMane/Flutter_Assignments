import '../entities/task_entity.dart';

class FilterAndSortTasks {
  List<TaskEntity> call(
    List<TaskEntity> tasks, {
    required bool filterByPriority,
    required bool filterByDueDate,
    String? priorityLevel,
  }) {
    List<TaskEntity> filteredTasks = tasks;

    // Filter by priority
    if (filterByPriority && priorityLevel != null) {
      filteredTasks = filteredTasks
          .where((task) => task.priority.toLowerCase() == priorityLevel.toLowerCase())
          .toList();
    }

    // Sort by due date, then alphabetically
    filteredTasks.sort((a, b) {
      if (filterByDueDate) {
        int dateComparison = a.dueDate.compareTo(b.dueDate);
        if (dateComparison == 0) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        }
        return dateComparison;
      }
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return filteredTasks;
  }
}
