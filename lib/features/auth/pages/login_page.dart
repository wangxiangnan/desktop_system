import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/constants/app_strings.dart';
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
    context.read<AuthBloc>().add(const AuthCopyrightRequested());
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
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) =>
              previous.copyrightText != current.copyrightText ||
              previous.backgroundImageUrl != current.backgroundImageUrl,
          builder: (context, state) {
            return Stack(
              children: [
                if (state.backgroundImageUrl.isNotEmpty)
                  Positioned.fill(
                    child: Image.network(
                      state.backgroundImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), bottomLeft: Radius.circular(32)),
                        child: Image.network(
                          'https://res.dasheng.top/ctms_log/log_two_bg.png',
                          height: 586,
                        ),
                      ),
                      Container(
                        width: 463,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.fromLTRB(50, 76, 50, 76),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppHeader(),
                              const SizedBox(height: 66),
                              UsernameField(controller: _usernameController),
                              const SizedBox(height: 24),
                              PasswordField(
                                controller: _passwordController,
                                obscurePassword: _obscurePassword,
                                onToggleVisibility: _onTogglePasswordVisibility,
                              ),
                              const SizedBox(height: 24),
                              CaptchaField(
                                controller: _captchaController,
                                captchaImage: _captchaImage,
                                captchaUuid: _captchaUuid,
                                onRefreshCaptcha: _loadCaptcha,
                                onFieldSubmitted: (_) => _onLogin(),
                              ),
                              const SizedBox(height: 56),
                              LoginButton(onPressed: _onLogin),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 60,
                  top: 26,
                  child: Image.asset(AppStrings.logoUrl, width: 260,),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      const Text(AppStrings.recordNumber, style: TextStyle(color: Colors.white)),
                      if (state.copyrightText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(state.copyrightText, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
