import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchaso/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:purchaso/features/product/data/datasources/product_remote_datasource';
import 'package:purchaso/features/product/data/repositories/product_repository_impl.dart';
import 'package:purchaso/features/product/domain/repositories/product_repository.dart';
import 'package:purchaso/features/product/domain/usecases/get_products.dart';
import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';
import 'package:purchaso/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:purchaso/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:purchaso/features/profile/domain/repositories/profile_repository.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_bloc.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Firebase Auth & Google Sign-In
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  // Remote Data Source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      firebaseAuth: serviceLocator<FirebaseAuth>(),
      googleSignIn: serviceLocator<GoogleSignIn>(),
    ),
  );

  serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
    () =>
        ProfileRemoteDataSource(firestore: serviceLocator<FirebaseFirestore>()),
  );

   serviceLocator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(serviceLocator<http.Client>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );
   serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: serviceLocator<ProfileRemoteDataSource>(),
    ),
   );
   serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
       serviceLocator<ProductRemoteDataSource>(),
    ),
  );
  //usecases
    serviceLocator.registerLazySingleton<GetProductsUsecase>(
    () => GetProductsUsecase(serviceLocator<ProductRepository>()),
  );

  // Bloc
  serviceLocator.registerFactory(() => AuthBloc(serviceLocator<AuthRepository>()));
  serviceLocator.registerFactory(() => ProfileBloc(profileRepository: serviceLocator<ProfileRepository>()));
  serviceLocator.registerFactory(
    () => ProductBloc(
      getProductsUsecase: serviceLocator<GetProductsUsecase>(),
    ),
  );

}

