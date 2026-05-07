import 'package:equatable/equatable.dart';
import 'package:desktop_system/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure, captchaLoading, captchaLoaded }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? captchaImage;
  final String? uuid;
  final String copyrightText;
  final String backgroundImageUrl;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.captchaImage,
    this.uuid,
    this.copyrightText = '',
    this.backgroundImageUrl = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? captchaImage,
    String? uuid,
    String? copyrightText,
    String? backgroundImageUrl,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      captchaImage: captchaImage ?? this.captchaImage,
      uuid: uuid ?? this.uuid,
      copyrightText: copyrightText ?? this.copyrightText,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, captchaImage, uuid, copyrightText, backgroundImageUrl];
}