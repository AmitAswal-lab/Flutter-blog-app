import 'package:bloc_app_clean_solidp_bloc/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future< Either<Failure,String>> signupWithEmailPassword(
    {required String email, required String name, required String password}
  );
  Future< Either<Failure,String>> loginWithEmailPassword(
    {required String email, required String password}
  );
}
