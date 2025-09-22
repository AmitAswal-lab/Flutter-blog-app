import 'package:bloc_app_clean_solidp_bloc/core/secrets/supabase_secrets.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/repository/auth_repository.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_login.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_signup.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serverLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    anonKey: SupabaseSecrets.anonKey,
    url: SupabaseSecrets.supabaseUrl,
  );
  serverLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);
}

void _initAuth() {
  serverLocator.registerFactory<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(serverLocator()),
  );
  serverLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serverLocator()),
  );
  serverLocator.registerFactory(() => UserSignup(serverLocator()));
  serverLocator.registerFactory(() => UserLogin(serverLocator()));
  serverLocator.registerLazySingleton(
    () => AuthBloc(userSignup: serverLocator(), userLogin: serverLocator()),
  );
}
