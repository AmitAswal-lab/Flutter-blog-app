import 'package:bloc_app_clean_solidp_bloc/core/error/exceptions.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDatasource {
  Session? get currentSession;
  Future<UserModel?> getCurrentUserData();

  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabaseClient;
  AuthRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException('User is Null');
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentSession!.user.email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerException('User is Null');
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentSession!.user.email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get currentSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentSession!.user.id);
        return UserModel.fromJson(
          userData.first,
        ).copyWith(email: currentSession!.user.email);
      }
      return null;
    } on ServerException catch (e) {
      throw ServerException(e.message);
    }
  }
}
