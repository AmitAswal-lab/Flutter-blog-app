import 'package:bloc_app_clean_solidp_bloc/core/error/exceptions.dart';
import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_app_clean_solidp_bloc/core/common/enitites/user.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  AuthRepositoryImpl(this.authRemoteDatasource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDatasource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
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
}
