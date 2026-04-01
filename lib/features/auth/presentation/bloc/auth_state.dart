import 'package:equatable/equatable.dart';
import 'package:desktop_system/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthCaptchaLoaded extends AuthState {
  final String captchaImage;
  final String uuid;

  const AuthCaptchaLoaded({required this.captchaImage, required this.uuid});

  @override
  List<Object?> get props => [captchaImage, uuid];
}

class AuthCaptchaLoading extends AuthState {
  const AuthCaptchaLoading();
}
