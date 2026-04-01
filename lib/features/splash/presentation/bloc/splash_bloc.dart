import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:desktop_system/services/storage_service.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final StorageService _storageService = getIt<StorageService>();
  static const int _totalSeconds = 8;
  Timer? _timer;

  SplashBloc() : super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
    on<SplashSkipRequested>(_onSplashSkipRequested);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading(remainingSeconds: _totalSeconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = _totalSeconds - timer.tick;

      if (remaining <= 0) {
        timer.cancel();
        _navigateToNext(emit);
      } else {
        emit(SplashLoading(remainingSeconds: remaining));
      }
    });
  }

  Future<void> _onSplashSkipRequested(
    SplashSkipRequested event,
    Emitter<SplashState> emit,
  ) async {
    _timer?.cancel();
    _navigateToNext(emit);
  }

  void _navigateToNext(Emitter<SplashState> emit) {
    if (_storageService.isLoggedIn) {
      emit(const SplashAuthenticated());
    } else {
      emit(const SplashUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
