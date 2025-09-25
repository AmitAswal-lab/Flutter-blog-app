import 'package:bloc_app_clean_solidp_bloc/core/error/exceptions.dart';
import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:bloc_app_clean_solidp_bloc/core/network/connection_checker.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/core/common/enitites/user.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/models/user_model.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(this.authRemoteDatasource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = authRemoteDatasource.currentSession;
        if (session == null) {
          return left(Failure('User not logged in'));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? ' ',
            name: '',
          ),
        );
      }

      final user = await authRemoteDatasource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () => authRemoteDatasource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signupWithEmailPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDatasource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        left(Failure('No Internet Connection!'));
      }
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
