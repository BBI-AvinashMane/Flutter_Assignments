import 'package:get_it/get_it.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Authentication
import 'features/authenticate/data/datasources/authenticate_remote_data_source.dart';
import 'features/authenticate/data/repositories/authenticate_repository_impl.dart';
import 'features/authenticate/domain/repositories/authenticate_repository.dart';
import 'features/authenticate/domain/usecases/login_user.dart';
import 'features/authenticate/domain/usecases/register_user.dart';
import 'features/authenticate/domain/usecases/logout_user.dart';
import 'features/authenticate/presentation/bloc/authenticate_bloc.dart';

// Task Management
import 'features/manage_task/data/repositories/task_repository_impl.dart';
import 'features/manage_task/domain/repositories/task_repository.dart';
import 'features/manage_task/domain/usecases/add_task.dart';
import 'features/manage_task/domain/usecases/delete_task.dart';
import 'features/manage_task/domain/usecases/filter_and_sort_task.dart';
import 'features/manage_task/domain/usecases/get_task.dart';
import 'features/manage_task/domain/usecases/update_task.dart';
import 'features/manage_task/presentation/bloc/task_bloc.dart';
import 'features/manage_task/data/datasources/manage_task_remote_data_source.dart';

final sl = GetIt.instance;


Future<void> init() async {
  // Register FirebaseDatabase
  sl.registerLazySingleton(() => FirebaseDatabase.instance);

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data Sources
  sl.registerLazySingleton<AuthenticateRemoteDataSource>(
      () => AuthenticateRemoteDataSourceImpl(sl<FirebaseDatabase>()));

  sl.registerLazySingleton<ManageTaskRemoteDataSource>(
      () => ManageTaskRemoteDataSourceImpl(sl<FirebaseDatabase>()));

  // Repositories
  sl.registerLazySingleton<AuthenticateRepository>(
      () => AuthenticateRepositoryImpl(sl<AuthenticateRemoteDataSource>()));
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(sl<ManageTaskRemoteDataSource>()));

  // Use Cases
  // Authentication
  sl.registerLazySingleton(() => RegisterUser(sl<AuthenticateRepository>()));
  sl.registerLazySingleton(() => LoginUser(sl<AuthenticateRepository>()));
  sl.registerLazySingleton(() => LogoutUser(sl<AuthenticateRepository>()));

  // Task Feature
  sl.registerLazySingleton(() => AddTask(sl<TaskRepository>()));
  sl.registerLazySingleton(() => DeleteTask(sl<TaskRepository>()));
  sl.registerLazySingleton(() => FilterAndSortTasks());
  sl.registerLazySingleton(() => GetTasks(sl<TaskRepository>()));
  sl.registerLazySingleton(() => UpdateTask(sl<TaskRepository>()));

  // Bloc
  sl.registerFactory(() => AuthenticateBloc(
        registerUser: sl<RegisterUser>(),
        loginUser: sl<LoginUser>(),
        logoutUser: sl<LogoutUser>(),
        preferences: sl<SharedPreferences>(),
      ));

  sl.registerFactory(() => TaskBloc(
        getTasks: sl<GetTasks>(),
        addTask: sl<AddTask>(),
        updateTask: sl<UpdateTask>(),
        deleteTask: sl<DeleteTask>(),
        filterAndSortTasks: sl<FilterAndSortTasks>(),
        preferences: sl<SharedPreferences>(),
      ));
}
