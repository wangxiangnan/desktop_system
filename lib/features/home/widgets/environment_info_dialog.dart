import 'package:desktop_system/core/config/app_config.dart';
import 'package:flutter/material.dart';

class EnvironmentInfoDialog extends StatelessWidget {
  const EnvironmentInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Environment Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('App Name: ${AppConfig.appName}'),
          Text('Environment: ${AppConfig.environment}'),
          Text('API Base URL: ${AppConfig.apiBaseUrl}'),
          Text('Debug Mode: ${AppConfig.debugMode}'),
          Text('Log Level: ${AppConfig.logLevel}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
