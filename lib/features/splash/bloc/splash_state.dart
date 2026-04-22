import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  final int remainingSeconds;

  const SplashLoading({required this.remainingSeconds});

  @override
  List<Object?> get props => [remainingSeconds];
}

class SplashCompleted extends SplashState {
  const SplashCompleted();
}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
