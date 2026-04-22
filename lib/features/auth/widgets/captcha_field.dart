import 'dart:convert';
import 'package:flutter/material.dart';

class CaptchaField extends StatelessWidget {
  final TextEditingController controller;
  final String captchaImage;
  final String captchaUuid;
  final VoidCallback onRefreshCaptcha;
  final void Function(String)? onFieldSubmitted;

  const CaptchaField({
    super.key,
    required this.controller,
    required this.captchaImage,
    required this.captchaUuid,
    required this.onRefreshCaptcha,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '验证码',
              prefixIcon: Icon(Icons.security),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入验证码';
              }
              return null;
            },
            onFieldSubmitted: onFieldSubmitted != null
                ? (value) => onFieldSubmitted!(value)
                : null,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onRefreshCaptcha,
          child: Container(
            width: 120,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: captchaImage.isNotEmpty
                ? Image.memory(
                    base64Decode(captchaImage.split(',').last),
                    fit: BoxFit.contain,
                    key: ValueKey(captchaUuid),
                  )
                : const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
          ),
        ),
      ],
    );
  }
}
