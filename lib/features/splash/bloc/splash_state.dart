import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final bool isInitial;
  final bool isLoading;
  final bool isCompleted;
  final bool hasError;
  final int remainingSeconds;
  final String? errorMessage;

  const SplashState({
    this.isInitial = false,
    this.isLoading = false,
    this.isCompleted = false,
    this.hasError = false,
    this.remainingSeconds = 3,
    this.errorMessage,
  });

  SplashState copyWith({
    bool? isInitial,
    bool? isLoading,
    bool? isCompleted,
    bool? hasError,
    int? remainingSeconds,
    String? errorMessage
  }) {
    return SplashState(
      isInitial: isInitial ?? this.isInitial,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      hasError: hasError ?? this.hasError,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isInitial,
    isLoading,
    isCompleted,
    hasError,
    remainingSeconds,
    errorMessage
  ];
}
