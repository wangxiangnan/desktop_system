import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

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
        super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthCaptchaRequested>(_onCaptchaRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(LoginParams(
      username: event.username,
      password: event.password,
      code: event.code,
      uuid: event.uuid,
    ));

    result.when(
      success: (user) => emit(AuthAuthenticated(user)),
      failure: (error) => emit(AuthError(error.message)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _logoutUseCase();

    result.when(
      success: (_) => emit(const AuthUnauthenticated()),
      failure: (error) => emit(AuthError(error.message)),
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
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
      failure: (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onCaptchaRequested(
    AuthCaptchaRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthCaptchaLoading());

    final result = await _getCaptchaUseCase();

    result.when(
      success: (captcha) => emit(AuthCaptchaLoaded(
        captchaImage: captcha.imageBase64,
        uuid: captcha.uuid,
      )),
      failure: (error) => emit(AuthError(error.message)),
    );
  }
}
