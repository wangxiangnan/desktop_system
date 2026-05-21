import 'package:flutter/material.dart';
import 'package:desktop_system/core/constants/app_colors.dart';

class DictLabel extends StatelessWidget {
  final Map<String, String> dict;
  final String value;
  final TextStyle? style;
  final String? fallback;

  const DictLabel({
    super.key,
    required this.dict,
    required this.value,
    this.style,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final label = dict[value];
    if (label != null) {
      return Text(label, style: style);
    }
    return Text(
      fallback ?? value,
      style: (style ?? const TextStyle()).copyWith(color: AppColors.textSecondary),
    );
  }
}
