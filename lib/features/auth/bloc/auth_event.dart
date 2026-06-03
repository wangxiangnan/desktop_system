import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String username,
    required String password,
    required String code,
    required String uuid,
  }) = AuthLoginRequested;

  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;

  const factory AuthEvent.checkRequested() = AuthCheckRequested;

  const factory AuthEvent.captchaRequested() = AuthCaptchaRequested;

  const factory AuthEvent.copyrightRequested() = AuthCopyrightRequested;
}
