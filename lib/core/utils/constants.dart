class Constants {
  // Firebase Database Paths
  static const String users = "users";
  static const String usersPath = "users/";
  static const String tasksPath = "tasks";
  static const String userCount = 'user_count';
  static const String userIdPrefix = 'user_';
  static const String userId = 'userId';
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
  static const String unExpectedState="Unexpected state.";
  static const String error = 'Error: ';
  static const String pageError = "404 - Page Not Found";
  static const String pageNotFoundError = 'Page Not Found.';


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
  static const String taskManagement = "Task Management";
  

  // Authentication
  static const String authenticationTitle='Authentication';
  static const String registerButton='Register';

  static const String confirmLogoutTitle = 'Confirm Logout';
  static const String confirmLogoutMessage =
      'Are you sure you want to log out?';
  static const String logoutButton = 'Logout';
  static const String loginButton = 'Login';
  static const String cancelButton = 'Cancel';

  // Drawer
  static const String drawerLogout = 'Logout';
  static const String drawerMenu = 'Open navigation menu';

  // Tasks
  static const String task="task";
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
  static const String taskAddTitle='Add Task';
  static const String taskEditTitle='Edit Task';

  //TaskList
  static const String titleList='Title: ';
  static const String descriptionList='Description: ';
  static const String overdueByList='Overdue by: ';
  static const String priorityList='Priority: ';
  static const String dueDateList='Due Date: ';
  static const String hours='hours';

//LoginScreen
static const String loginScreenTitle = 'Login';
static const String appBarLoginTitle = 'appBarLoginTitle';
static const String userIDInput = "Enter your User ID to log in:";
static const String userIDInputLabel = 'User ID';
static const String userIdEmptyValidation= 'User ID cannot be empty';

//Logout Dialogue box
  static const String logoutTitle = "Logout";
  static const String logoutonfirmation = "Are you sure you want to log out?";
  static const String logoutCancelText = "Cancel";

  //MenuDrawer
   static const String welcomeText="Welcome";
   static const String logoutText="Logout";
 
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
  

  // Miscellaneous
  static const String userNumberPrefix = 'User Number: ';
  static const String loadingMessage = 'Loading...';

  //keys for testing
  static const String appBarTitleKey='appBarTitle';
  static const String titleFieldKey='titleField';
  static const String addUpdateTaskButtonKey='addUpdateTaskButton';
  static const String addUpdateTaskButton='addUpdateTaskButton';
  static const String addTaskButton='addTaskButton';
  static const String taskListAppBar='taskListAppBar';
  static const String userIdTextField='userIdTextField';
  static const String loginButtonKey='loginButton';
  static const String logoutDialogTitleKey='logoutDialogTitle';
  static const String logoutDialogContentKey='logoutDialogContent';
  static const String cancelButtonKey = 'cancelButton';
  static const String logoutButtonKey='logoutButton';



  //constatnts for routes
  static const String taskFilterRoute='/task_filter';
  static const String route='/';
  static const String taskFormRoute='/task_form';
  static const String loginRoute='/login';
  static const String tasksRoute='/tasks';
  static const String logOutRoute='/logout';
}
