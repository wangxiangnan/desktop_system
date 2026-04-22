import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.directions_bus, size: 64, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          AppStrings.appName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
