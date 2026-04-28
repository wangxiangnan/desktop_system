import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/domain/usecases/usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase _authUseCase;

  AuthBloc({required AuthUseCase authUseCase})
      : _authUseCase = authUseCase,
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

    final result = await _authUseCase.login(LoginParams(
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

    final result = await _authUseCase.logout();

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
    final result = await _authUseCase.getCurrentUser();

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

    final result = await _authUseCase.getCaptcha();

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