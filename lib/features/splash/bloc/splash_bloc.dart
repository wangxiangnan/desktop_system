import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  static const int _totalSeconds = 3;

  SplashBloc() : super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
    on<SplashSkipRequested>(_onSplashSkipRequested);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading(remainingSeconds: _totalSeconds));
    await _countdown(emit);
  }

  Future<void> _countdown(Emitter<SplashState> emit) async {
    for (int i = _totalSeconds - 1; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (i == 0) {
        emit(const SplashCompleted());
      } else {
        emit(SplashLoading(remainingSeconds: i));
      }
    }
  }

  Future<void> _onSplashSkipRequested(
    SplashSkipRequested event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashCompleted());
  }
}
