import 'package:get_it/get_it.dart';
import 'package:firebase_database/firebase_database.dart';
import 'features/authenticate/data/datasources/authenticate_remote_data_source.dart';
import 'features/authenticate/data/repositories/authenticate_repository_impl.dart';
import 'features/authenticate/domain/repositories/authenticate_repository.dart';
import 'features/authenticate/domain/usecases/login_user.dart';
import 'features/authenticate/domain/usecases/register_user.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register FirebaseDatabase
  sl.registerLazySingleton(() => FirebaseDatabase.instance);

  // Data Sources
  sl.registerLazySingleton<AuthenticateRemoteDataSource>(
      () => AuthenticateRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<AuthenticateRepository>(
      () => AuthenticateRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
}
