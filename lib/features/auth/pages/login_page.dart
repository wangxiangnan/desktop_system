import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _obscurePassword = true;
  String _captchaImage = '';
  String _captchaUuid = '';

  @override
  void initState() {
    super.initState();
    _loadCaptcha();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _loadCaptcha() {
    context.read<AuthBloc>().add(const AuthCaptchaRequested());
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          code: _captchaController.text.trim(),
          uuid: _captchaUuid,
        ),
      );
    }
  }

  void _updateCaptcha(String image, String uuid) {
    setState(() {
      _captchaImage = image;
      _captchaUuid = uuid;
    });
  }

  void _onTogglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure) {
            _loadCaptcha();
          } else if (state.status == AuthStatus.captchaLoaded) {
            _updateCaptcha(state.captchaImage!, state.uuid!);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: LoginCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppHeader(),
                    const SizedBox(height: 32),
                    UsernameField(controller: _usernameController),
                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _passwordController,
                      obscurePassword: _obscurePassword,
                      onToggleVisibility: _onTogglePasswordVisibility,
                    ),
                    const SizedBox(height: 16),
                    CaptchaField(
                      controller: _captchaController,
                      captchaImage: _captchaImage,
                      captchaUuid: _captchaUuid,
                      onRefreshCaptcha: _loadCaptcha,
                      onFieldSubmitted: (_) => _onLogin(),
                    ),
                    const SizedBox(height: 24),
                    LoginButton(onPressed: _onLogin),
                    const SizedBox(height: 16),
                    const CaptchaHint(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
