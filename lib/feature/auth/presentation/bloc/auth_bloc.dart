import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  AuthBloc({required UserSignup userSignup})
    : _userSignup = userSignup,
      super(AuthInitial()) {
    on<AuthSignup>((event, emit) async {
      final response = await _userSignup(
        UserSignupParams(
          name: event.name,
          email: event.email,
          password: event.paswword,
        ),
      );
      response.fold(
        (onLeft) => emit(AuthFailure(onLeft.message)),
        (onRight) => emit(AuthSuccess(onRight)),
      );
    });
  }
}
