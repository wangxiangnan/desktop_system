import 'package:flutter/material.dart';

class CreateCanvasDialog extends StatefulWidget {
  final Function(String name, double width, double height) onCreate;

  const CreateCanvasDialog({super.key, required this.onCreate});

  @override
  State<CreateCanvasDialog> createState() => _CreateCanvasDialogState();
}

class _CreateCanvasDialogState extends State<CreateCanvasDialog> {
  final _nameController = TextEditingController();
  double _width = 400;
  double _height = 300;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Canvas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter canvas name',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Width'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: _width.toString()),
                  onChanged: (v) => _width = double.tryParse(v) ?? _width,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Height'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: _height.toString()),
                  onChanged: (v) => _height = double.tryParse(v) ?? _height,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onCreate(_nameController.text, _width, _height);
              Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
