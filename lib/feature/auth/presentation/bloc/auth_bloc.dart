import 'package:bloc_app_clean_solidp_bloc/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:bloc_app_clean_solidp_bloc/core/usecase/usecase.dart';
import 'package:bloc_app_clean_solidp_bloc/core/common/enitites/user.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/current_user.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_login.dart';
import 'package:bloc_app_clean_solidp_bloc/feature/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignup userSignup,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignup = userSignup,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignup>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggin>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(AuthIsUserLoggin event, Emitter<AuthState> emit) async {
    final result = await _currentUser(NoParams());
    result.fold(
      (onLeft) => emit(AuthFailure(onLeft.message)),
      (onRight) => _emitAuthSuccess(onRight, emit),
    );
  }

  void _onAuthSignup(AuthSignup event, Emitter<AuthState> emit) async {
    final response = await _userSignup(
      UserSignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (onLeft) => emit(AuthFailure(onLeft.message)),
      (onRight) => _emitAuthSuccess(onRight, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final response = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );
    response.fold(
      (onLeft) => emit(AuthFailure(onLeft.message)),
      (onRight) => _emitAuthSuccess(onRight, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
