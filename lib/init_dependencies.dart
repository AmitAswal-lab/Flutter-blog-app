import 'package:bloc_app_clean_solidp_bloc/core/common/cubits/app_user/app_user_cubit.dart';
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
import 'package:bloc_app_clean_solidp_bloc/feature/blog/domain/usecases/upload_blog.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serverLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    anonKey: SupabaseSecrets.anonKey,
    url: SupabaseSecrets.supabaseUrl,
  );
  serverLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);
  //core
  serverLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //DataSource
  serverLocator
    ..registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(serverLocator()),
    )
    //Repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(serverLocator()))
    //Usecases
    ..registerFactory(() => UserSignup(serverLocator()))
    ..registerFactory(() => UserLogin(serverLocator()))
    ..registerFactory(() => CurrentUser(serverLocator()))
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignup: serverLocator(),
        userLogin: serverLocator(),
        currentUser: serverLocator(),
        appUserCubit: serverLocator(),
      ),
    );
}

void _initBlog() {
  //DataSource
  serverLocator
    ..registerFactory<BlogRemoteDatasource>(
      () => BlogRemoteDatasourceImpl(serverLocator()),
    )
    //repository
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(serverLocator()))
    //Usecases
    ..registerFactory(() => UploadBlog(serverLocator()))
    //Bloc
    ..registerLazySingleton(() => BlogBloc(serverLocator()));
}
