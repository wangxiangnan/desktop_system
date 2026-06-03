import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:desktop_system/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
  captchaLoading,
  captchaLoaded,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    User? user,
    String? errorMessage,
    String? captchaImage,
    String? uuid,
    @Default('') String copyrightText,
    @Default('') String backgroundImageUrl,
  }) = _AuthState;
}
