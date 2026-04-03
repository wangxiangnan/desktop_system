import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/data/repositories/auth_repository.dart';
import 'package:desktop_system/data/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  UserModel? _currentUser;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthCaptchaRequested>(_onCaptchaRequested);
  }

  UserModel? get currentUser => _currentUser;

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.login(
        event.username,
        event.password,
        event.code,
        event.uuid,
      );
      _currentUser = user;
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.logout();
      _currentUser = null;
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onCaptchaRequested(
    AuthCaptchaRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthCaptchaLoading());

    try {
      final captchaData = await _authRepository.getCaptchaImage();
      print('Captcha data: $captchaData');
      emit(
        AuthCaptchaLoaded(
          captchaImage: captchaData['img']!,
          uuid: captchaData['uuid']!,
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
