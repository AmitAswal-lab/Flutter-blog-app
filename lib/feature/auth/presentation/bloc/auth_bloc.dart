import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/entities/user.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_login.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  AuthBloc({required UserSignup userSignup, required UserLogin userLogin})
    : _userSignup = userSignup,
      _userLogin = userLogin,
      super(AuthInitial()) {
    on<AuthSignup>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
  }
  void _onAuthSignup(AuthSignup event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userSignup(
      UserSignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (onLeft) => emit(AuthFailure(onLeft.message)),
      (onRight) => emit(AuthSuccess(onRight)),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );
    response.fold(
      (onLeft) => emit(AuthFailure(onLeft.message)),
      (onRight) => emit(AuthSuccess(onRight)),
    );
  }
}
