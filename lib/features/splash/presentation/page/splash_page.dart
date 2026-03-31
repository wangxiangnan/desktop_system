import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback onUnauthenticated;

  const SplashPage({
    super.key,
    required this.onAuthenticated,
    required this.onUnauthenticated,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = context.read<SplashBloc>();
    _splashBloc.add(const SplashStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          widget.onAuthenticated();
        } else if (state is SplashUnauthenticated) {
          widget.onUnauthenticated();
        }
      },
      child: MaterialApp(
        home: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_bus,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.splashTitle,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: BlocBuilder<SplashBloc, SplashState>(
                  builder: (context, state) {
                    final remaining = state is SplashLoading
                        ? state.remainingSeconds
                        : 8;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$remaining',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            _splashBloc.add(const SplashSkipRequested());
                          },
                          child: const Text(
                            'Skip >>',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
