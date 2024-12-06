import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_using_bloc/features/managetask/data/data-sources/todo_local_data_source.dart';
import 'package:to_do_using_bloc/features/managetask/data/repository/todo_repository_impl.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/add_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/delete_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/edit_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/get_todo_list.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_bloc.dart';
final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Data Sources
  sl.registerLazySingleton<ToDoLocalDataSource>(
      () => ToDoLocalDataSourceImpl(sl()));

  //! Repositories
  sl.registerLazySingleton<ToDoRepository>(
      () => ToDoRepositoryImpl(sl()));

  //! Use Cases
  sl.registerLazySingleton(() => AddToDo(sl()));
  sl.registerLazySingleton(() => EditToDo(sl()));
  sl.registerLazySingleton(() => DeleteToDo(sl()));
  sl.registerLazySingleton(() => GetToDoList(sl()));

  //! BLoC
  sl.registerFactory(() => ToDoBloc(
        addToDo: sl(),
        editToDo: sl(),
        deleteToDo: sl(),
        getToDoList: sl(),
      ));
}
