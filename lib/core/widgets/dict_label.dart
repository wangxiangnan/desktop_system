import 'package:flutter/material.dart';
import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/core/services/dict_service.dart';

class DictLabel extends StatelessWidget {
  final Map<String, String>? _dict;
  final String? _dictId;
  final String value;
  final TextStyle? style;
  final String? fallback;

  const DictLabel({
    super.key,
    required Map<String, String> dict,
    required this.value,
    this.style,
    this.fallback,
  }) : _dict = dict, _dictId = null;

  const DictLabel.auto({
    super.key,
    required String dictId,
    required this.value,
    this.style,
    this.fallback,
  }) : _dict = null, _dictId = dictId;

  @override
  Widget build(BuildContext context) {
    final label = _resolveLabel();
    if (label != null) {
      return Text(label, style: style);
    }
    return Text(
      fallback ?? value,
      style: (style ?? const TextStyle()).copyWith(color: AppColors.textSecondary),
    );
  }

  String? _resolveLabel() {
    if (_dict != null) return _dict[value];
    if (_dictId != null) {
      final cached = getIt<DictService>().getCachedLabel(_dictId, value);
      if (cached != null) return cached;
    }
    return null;
  }
}
