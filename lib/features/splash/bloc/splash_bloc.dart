import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  SplashBloc() : super(const SplashState()) {
    on<SplashStarted>(_onSplashStarted);
    on<SplashSkipRequested>(_onSplashSkipRequested);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _countdown(emit);
  }

  Future<void> _countdown(Emitter<SplashState> emit) async {
    for (int i = state.remainingSeconds; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (i == 0) {
        emit(state.copyWith(isCompleted: true, isLoading: false));
      } else {
        emit(state.copyWith(remainingSeconds: i));
      }
    }
  }

  Future<void> _onSplashSkipRequested(
    SplashSkipRequested event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(isCompleted: true, isLoading: false));
  }
}
