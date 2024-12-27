// import 'package:get_it/get_it.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'features/authenticate/data/datasources/authenticate_remote_data_source.dart';
// import 'features/authenticate/data/repositories/authenticate_repository_impl.dart';
// import 'features/authenticate/domain/repositories/authenticate_repository.dart';
// import 'features/authenticate/domain/usecases/login_user.dart';
// import 'features/authenticate/domain/usecases/register_user.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // Register FirebaseDatabase
//   sl.registerLazySingleton(() => FirebaseDatabase.instance);

//   // Data Sources
//   sl.registerLazySingleton<AuthenticateRemoteDataSource>(
//       () => AuthenticateRemoteDataSourceImpl(sl()));

//   // Repositories
//   sl.registerLazySingleton<AuthenticateRepository>(
//       () => AuthenticateRepositoryImpl(sl()));

//   // Use Cases
//   sl.registerLazySingleton(() => RegisterUser(sl()));
//   sl.registerLazySingleton(() => LoginUser(sl()));
// }
import 'package:get_it/get_it.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/authenticate/data/datasources/authenticate_remote_data_source.dart';
import 'features/authenticate/data/repositories/authenticate_repository_impl.dart';
import 'features/authenticate/domain/repositories/authenticate_repository.dart';
import 'features/authenticate/domain/usecases/login_user.dart';
import 'features/authenticate/domain/usecases/register_user.dart';
import 'features/manage_task/data/repositories/task_repository_impl.dart';
import 'features/manage_task/domain/repositories/task_repository.dart';
import 'features/manage_task/domain/usecases/add_task.dart';
import 'features/manage_task/domain/usecases/delete_task.dart';
import 'features/manage_task/domain/usecases/filter_and_sort_task.dart';
import 'features/manage_task/domain/usecases/get_task.dart';
import 'features/manage_task/domain/usecases/update_task.dart';
import 'features/manage_task/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register FirebaseDatabase
  sl.registerLazySingleton(() => FirebaseDatabase.instance);

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data Sources
  sl.registerLazySingleton<AuthenticateRemoteDataSource>(
      () => AuthenticateRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<AuthenticateRepository>(
      () => AuthenticateRepositoryImpl(sl()));

  // Task Repository
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(sl()));

  // Use Cases
  // Authentication
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));

  // Task Feature
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => FilterAndSortTasks());
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));

  // Bloc
  sl.registerFactory(() => TaskBloc(
        getTasks: sl(),
        filterAndSortTasks: sl(),
        preferences: sl(),
        deleteTask: sl(),
      ));
}
