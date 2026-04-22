import 'package:flutter/material.dart';

class SvgEmptyState extends StatelessWidget {
  const SvgEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No SVG canvases found'),
          SizedBox(height: 8),
          Text('Create a new canvas to get started'),
        ],
      ),
    );
  }
}
