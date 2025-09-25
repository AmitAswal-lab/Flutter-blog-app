import 'package:bloc_app_clean_solidp_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:bloc_app_clean_solidp_bloc/core/network/connection_checker.dart';
import 'package:bloc_app_clean_solidp_bloc/core/secrets/supabase_secrets.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/repository/auth_repository.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/current_user.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_login.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_signup.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/datasources/blog_remote_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/data/repository/blog_repository_impl.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/repository/blog_repository.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/usecases/upload_blog.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    anonKey: SupabaseSecrets.anonKey,
    url: SupabaseSecrets.supabaseUrl,
  );
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());
  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  //DataSource
  serviceLocator
    ..registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(serviceLocator()),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    //Usecases
    ..registerFactory(() => UserSignup(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignup: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //DataSource
  serviceLocator
    ..registerFactory<BlogRemoteDatasource>(
      () => BlogRemoteDatasourceImpl(serviceLocator()),
    )
    //repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(serviceLocator()),
    )
    //Usecases
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerFactory(() => UploadBlog(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}
