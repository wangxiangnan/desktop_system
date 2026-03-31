import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'app_sidebar.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const AppShell({super.key, required this.child, required this.currentPath});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            currentPath: widget.currentPath,
            isExpanded: _isExpanded,
            onExpandedChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
            },
          ),
          Expanded(
            child: Container(color: AppColors.background, child: widget.child),
          ),
        ],
      ),
    );
  }
}
