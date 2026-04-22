import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/domain/repositories/svg_repository.dart';
import 'package:desktop_system/domain/entities/svg_entity.dart';
import 'package:desktop_system/features/svg/bloc/svg_bloc.dart';
import 'package:desktop_system/features/svg/bloc/svg_event.dart';
import 'package:desktop_system/features/svg/bloc/svg_state.dart';

class SvgListPage extends StatelessWidget {
  const SvgListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SvgBloc(getIt<SvgRepository>())..add(const SvgLoadRequested()),
      child: const _SvgListView(),
    );
  }
}

class _SvgListView extends StatelessWidget {
  const _SvgListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SVG Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<SvgBloc, SvgState>(
        builder: (context, state) {
          if (state is SvgLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SvgError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SvgBloc>().add(const SvgLoadRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SvgListLoaded) {
            if (state.canvases.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No SVG canvases found'),
                    SizedBox(height: 8),
                    Text('Create a new canvas to get started'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.canvases.length,
              itemBuilder: (context, index) {
                final canvas = state.canvases[index];
                return _SvgCanvasCard(
                  canvas: canvas,
                  onTap: () => context.push('/svg/${canvas.id}'),
                  onDelete: () => _showDeleteDialog(context, canvas),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    double width = 400;
    double height = 300;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Canvas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
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
                      controller: TextEditingController(text: width.toString()),
                      onChanged: (v) => width = double.tryParse(v) ?? width,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Height'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: height.toString(),
                      ),
                      onChanged: (v) => height = double.tryParse(v) ?? height,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  context.read<SvgBloc>().add(
                    SvgCanvasCreated(
                      name: nameController.text,
                      width: width,
                      height: height,
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, SvgCanvas canvas) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Canvas'),
        content: Text('Are you sure you want to delete "${canvas.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              context.read<SvgBloc>().add(SvgCanvasDeleted(canvas.id));
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SvgCanvasCard extends StatelessWidget {
  final SvgCanvas canvas;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SvgCanvasCard({
    required this.canvas,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 32, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      canvas.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${canvas.width.toInt()} x ${canvas.height.toInt()} • ${canvas.elements.length} elements',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Updated: ${_formatDate(canvas.updatedAt)}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
