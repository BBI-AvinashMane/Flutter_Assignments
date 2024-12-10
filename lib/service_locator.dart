
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_using_bloc/features/managetask/data/data-sources/todo_local_data_source.dart';
import 'package:to_do_using_bloc/features/managetask/data/repository/todo_repository_impl.dart';
import 'package:to_do_using_bloc/features/managetask/domain/repository/todo_repository.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/add_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/delete_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/edit_todo.dart';
import 'package:to_do_using_bloc/features/managetask/domain/usecases/get_todo_list.dart';
import 'package:to_do_using_bloc/features/managetask/presentation/bloc/todo_bloc.dart';




final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Initialize SharedPreferences asynchronously
  final sharedPreferences = await SharedPreferences.getInstance();

  // Register dependencies
  locator.registerLazySingleton<ToDoLocalDataSource>(() => ToDoLocalDataSourceImpl( sharedPreferences));

  locator.registerLazySingleton<ToDoRepository>(() => ToDoRepositoryImpl( locator()));

  // Register use cases
  locator.registerLazySingleton<AddToDo>(() => AddToDo( locator()));
  locator.registerLazySingleton<EditToDo>(() => EditToDo(locator()));
  locator.registerLazySingleton<DeleteToDo>(() => DeleteToDo(locator()));
  locator.registerLazySingleton<GetToDoList>(() => GetToDoList(locator()));


  // Register TodoBloc (factory for fresh instances)
  locator.registerFactory<ToDoBloc>(() => ToDoBloc(
    addToDo: locator(),
    editToDo: locator(),
    deleteToDo: locator(),
    getToDoList: locator(),
  ));
}