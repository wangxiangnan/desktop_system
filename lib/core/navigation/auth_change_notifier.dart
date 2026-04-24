import 'package:flutter/material.dart';
import 'package:desktop_system/features/auth/bloc/auth_bloc.dart';
import 'package:desktop_system/features/auth/bloc/auth_state.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;

  AuthChangeNotifier(this._authBloc) {
    _authBloc.stream.listen((state) {
      notifyListeners();
    });
  }

  bool get isAuthenticated {
    final state = _authBloc.state;
    return state.status == AuthStatus.authenticated && state.user != null;
  }

  bool get isLoading {
    return _authBloc.state.status == AuthStatus.loading ||
        _authBloc.state.status == AuthStatus.captchaLoading;
  }
}