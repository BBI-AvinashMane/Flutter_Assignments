class Constants {
  // Firebase Database Paths
  static const String users = "users";
  static const String usersPath = "users/";
  static const String tasksPath = "tasks";
  static const String userCount = "user_count";
  static const String userIdPrefix = 'user_';
  static const String userId = "userId";
  static const String registeredAt = "registeredAt";

  // Shared Preferences Keys
  static const String userIdKey = "user_id";
  static const String sortPreferenceKey = "sort_preference";

  // Priority Levels
  static const String priorityHigh = "high";
  static const String priorityMedium = "medium";
  static const String priorityLow = "low";

// Errors-----------------------------------------------------------
  static const String genericErrorMessage = 'An unexpected error occurred.';
  // auth-Error Messages
  static const String unknownError = "An unknown error occurred.";
  static const String noConnectionError = "No internet connection.";
  static const String failedToRegisterUser = "Failed to register user ";
  static const String failedToLoginUser = "Failed to login user: ";
  static const String failedToLogoutUser = "Failed to logout user: ";
  static const String invalidCredentialsError =
      'Invalid credentials, please try again.';
  static const String invalidUserId = 'Invalid User ID';

  //task-Error Messages
  static const String faildToAddTask = "Failed to add task: ";
  static const String faildToUpdateTask = "Failed to update task: ";
  static const String faildToDeleteTask = "Failed to delete task: ";
  static const String faildToFetchTask = "Failed to fetch task: ";
  static const String priorityOrderOverSpecificPriority =
      "Cannot filter by specific priority when 'Priority Order' is selected.";
  static const String noUserIdFound = "No user ID found. Please log in.";
  static const String noTasksFoundMessage = 'No tasks available.';
//----------------------------------------------------------------------

  // General Messages
  static const String appName = 'Task Manager';
  static const String welcomeMessage = 'Welcome';

  // Authentication
  static const String confirmLogoutTitle = 'Confirm Logout';
  static const String confirmLogoutMessage =
      'Are you sure you want to log out?';
  static const String logoutButton = 'Logout';
  static const String cancelButton = 'Cancel';

  // Drawer
  static const String drawerLogout = 'Logout';
  static const String drawerMenu = 'Open navigation menu';

  // Tasks
  static const String taskDetails = "Task Details";
  static const String taskTitleLabel = 'Title';
  static const String taskDescription = 'Description';
  static const String taskDescriptionLabel = 'Description: ';
  static const String noTaskDescriptionProvided = "No description provided.";
  static const String taskDueDateLabel = 'Due Date: ';
   static const String selectDateLabel = "Select Date";
  static const String taskPriorityLabel = 'Priority: ';
  static const String taskPriority= 'Priority';
  static const String taskAddButton = 'Add Task';
  static const String taskUpdateButton = 'Update Task';
  static const String taskEditButton = 'Edit Task';
  static const String taskDeleteButton = 'Delete Task';
  static const String taskSaveButton = 'Save';
  static const String taskValidationError = 'Please provide valid inputs.';
  static const String taskValidationTitleEmpty = 'Task title cannot be empty.';
  static const String taskValidationDueDatePast =
      'Due date must be in the future.';

  // Filters and Sorting
  static const String filterTasks = "Filter Tasks";
  static const String filterByPriority = 'filterByPriority';
  static const String filterByPriorityOrder = 'filterByPriorityOrder';
  static const String priorityLevel = 'priorityLevel';
  static const String specificPriority = "specificPriority";
  static const String specificPriorityLabel = 'Specific Priority';
  static const String filterByDueDate = 'filterByDueDate';
  static const String sortByDuedate = "Sort by Due Date";
  static const String resetFilters = 'Reset Filters';
  static const String applyFilters = "Apply Filters";
  static const String priorityOrderCheckbox = 'priorityOrderCheckbox';
  static const String priorityOrderText =
      'Priority Order (High > Medium > Low)';
  static const String specificPriorityDropdown = 'specificPriorityDropdown';
  static const String priorityHighText = 'High';
  static const String priorityMediumText = 'Medium';
  static const String priorityLowText = 'Low';

  // Navigation
  static const String homeScreenTitle = 'Home';
  static const String taskListScreenTitle = 'Tasks';
  static const String loginScreenTitle = 'Login';

  // Miscellaneous
  static const String userNumberPrefix = 'User Number: ';
  static const String loadingMessage = 'Loading...';

  //keys for testing
  static const String appBarTitleKey='appBarTitle';
  static const String titleFieldKey='titleField';
  static const String addUpdateTaskButton='addUpdateTaskButton';
}
