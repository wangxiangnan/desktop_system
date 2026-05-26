import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AppSidebar extends StatefulWidget {
  final String currentPath;
  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;

  const AppSidebar({
    super.key,
    required this.currentPath,
    required this.isExpanded,
    required this.onExpandedChanged,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.isExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 250 : 72,
      color: AppColors.primary,
      child: Column(
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.all(isExpanded ? 16 : 12),
            child: isExpanded
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : const Icon(
                    Icons.directions_bus,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(context, '首页', Icons.home, '/home'),
                _buildMenuItem(
                  context,
                  '未出票列表',
                  Icons.shopping_cart,
                  '/orders',
                ),
                _buildMenuItem(
                  context,
                  'Settings',
                  Icons.settings,
                  '/settings',
                ),
                _buildMenuItem(
                  context,
                  '打印设置',
                  Icons.print,
                  '/print-settings',
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Padding(
            padding: EdgeInsets.all(isExpanded ? 16 : 12),
            child: isExpanded
                ? Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'v1.0.0',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white70,
                        ),
                        onPressed: () =>
                            widget.onExpandedChanged(!widget.isExpanded),
                        tooltip: 'Collapse',
                      ),
                    ],
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                    onPressed: () =>
                        widget.onExpandedChanged(!widget.isExpanded),
                    tooltip: 'Expand',
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    String path,
  ) {
    final isSelected =
        widget.currentPath == path || widget.currentPath.startsWith('$path/');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.2) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showExpandedTile = constraints.maxWidth > 100;
          return showExpandedTile
              ? ListTile(
                  leading: Icon(icon, color: Colors.white),
                  title: Text(title, style: const TextStyle(color: Colors.white)),
                  selected: isSelected,
                  onTap: () {
                    if (widget.currentPath != path) context.go(path);
                  },
                )
              : InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    if (widget.currentPath != path) context.go(path);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(icon, color: Colors.white),
                  ),
                );
        },
      ),
    );
  }
}
