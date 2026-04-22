import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;
  final String code;
  final String uuid;

  const AuthLoginRequested({
    required this.username,
    required this.password,
    required this.code,
    required this.uuid,
  });

  @override
  List<Object?> get props => [username, password, code, uuid];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthCaptchaRequested extends AuthEvent {
  const AuthCaptchaRequested();
}
