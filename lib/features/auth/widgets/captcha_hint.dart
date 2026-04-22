import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CaptchaHint extends StatelessWidget {
  const CaptchaHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '点击验证码图片可刷新',
      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
    );
  }
}
