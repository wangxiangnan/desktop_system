import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/domain/usecases/usecases.dart';
import 'package:desktop_system/features/auth/bloc/auth_event.dart';
import 'package:desktop_system/features/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetCaptchaUseCase _getCaptchaUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GetCaptchaUseCase getCaptchaUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _getCaptchaUseCase = getCaptchaUseCase,
        super(const AuthState()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthCaptchaRequested>(_onCaptchaRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _loginUseCase(LoginParams(
      username: event.username,
      password: event.password,
      code: event.code,
      uuid: event.uuid,
    ));

    result.when(
      success: (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      )),
      failure: (error) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _logoutUseCase();

    result.when(
      success: (_) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
      failure: (error) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase();

    result.when(
      success: (user) {
        if (user != null) {
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          ));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
      failure: (_) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
    );
  }

  Future<void> _onCaptchaRequested(
    AuthCaptchaRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.captchaLoading));

    final result = await _getCaptchaUseCase();

    result.when(
      success: (captcha) => emit(state.copyWith(
        status: AuthStatus.captchaLoaded,
        captchaImage: captcha.imageBase64,
        uuid: captcha.uuid,
      )),
      failure: (error) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: error.message,
      )),
    );
  }
}