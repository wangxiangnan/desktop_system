import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/data/repositories/svg_repository.dart';
import 'package:desktop_system/data/models/svg_model.dart';
import 'package:desktop_system/features/svg/presentation/bloc/svg_bloc.dart';
import 'package:desktop_system/features/svg/presentation/bloc/svg_event.dart';
import 'package:desktop_system/features/svg/presentation/bloc/svg_state.dart';

class SvgEditorPage extends StatelessWidget {
  final String canvasId;

  const SvgEditorPage({super.key, required this.canvasId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SvgBloc(getIt<SvgRepository>())..add(SvgCanvasSelected(canvasId)),
      child: const _SvgEditorView(),
    );
  }
}

class _SvgEditorView extends StatelessWidget {
  const _SvgEditorView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SvgBloc, SvgState>(
      builder: (context, state) {
        if (state is SvgLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SvgError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is SvgEditorLoaded) {
          return _SvgEditor(
            canvas: state.canvas,
            selectedElementId: state.selectedElementId,
          );
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}

enum SvgTool { select, pen, penBezier, rect, circle, text }

class _SvgEditor extends StatefulWidget {
  final SvgCanvasModel canvas;
  final String? selectedElementId;

  const _SvgEditor({required this.canvas, this.selectedElementId});

  @override
  State<_SvgEditor> createState() => _SvgEditorState();
}

class _SvgEditorState extends State<_SvgEditor> {
  SvgTool _currentTool = SvgTool.select;
  List<SvgPoint> _currentPath = [];
  List<SvgAnchorPoint> _currentAnchorPoints = [];
  String? _drawingElementId;
  String? _selectedAnchorId;
  String? _selectedHandleId;
  String? _selectedLayerId;

  List<SvgLayerModel> get _layers => widget.canvas.layers;
  SvgLayerModel? get _selectedLayer => _selectedLayerId != null
      ? _layers.firstWhere(
          (l) => l.id == _selectedLayerId,
          orElse: () => _layers.isNotEmpty
              ? _layers.first
              : SvgLayerModel(id: '', name: 'Default'),
        )
      : (_layers.isNotEmpty ? _layers.first : null);

  @override
  void initState() {
    super.initState();
    _selectedLayerId = widget.canvas.layers.isNotEmpty
        ? widget.canvas.layers.first.id
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.canvas.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.read<SvgBloc>().add(const SvgCanvasSaved());
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Canvas saved')));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.white,
            child: _ToolPanel(
              currentTool: _currentTool,
              onToolSelected: (tool) {
                setState(() {
                  _currentTool = tool;
                  if (tool != SvgTool.pen && tool != SvgTool.penBezier) {
                    _currentPath = [];
                    _currentAnchorPoints = [];
                  }
                });
              },
              onAddElement: (type) => _addElement(context, type),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Center(
                child: _SvgCanvas(
                  canvas: widget.canvas,
                  selectedElementId: widget.selectedElementId,
                  currentTool: _currentTool,
                  currentPath: _currentPath,
                  currentAnchorPoints: _currentAnchorPoints,
                  drawingElementId: _drawingElementId,
                  onElementSelected: (elementId) {
                    if (_currentTool == SvgTool.select) {
                      context.read<SvgBloc>().add(
                        SvgElementSelected(elementId),
                      );
                    }
                  },
                  onElementMoved: (elementId, x, y) {
                    context.read<SvgBloc>().add(
                      SvgElementMoved(elementId: elementId, x: x, y: y),
                    );
                  },
                  onPenPointAdded: (point) {
                    setState(() {
                      if (_currentTool == SvgTool.penBezier) {
                        final newAnchor = SvgAnchorPoint(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          x: point.x,
                          y: point.y,
                        );
                        _currentAnchorPoints = [
                          ..._currentAnchorPoints,
                          newAnchor,
                        ];
                      } else {
                        _currentPath = [..._currentPath, point];
                      }
                    });
                  },
                  onPenDrawingComplete: () {
                    if (_currentPath.isNotEmpty) {
                      _finishPenDrawing(context);
                    }
                  },
                  onPenDrawingStarted: (elementId) {
                    setState(() {
                      _drawingElementId = elementId;
                    });
                  },
                  onAnchorPointMoved: (elementId, anchor) {
                    _updateAnchorPoint(elementId, anchor);
                  },
                  onHandleMoved: (elementId, handleKey, x, y) {
                    _updateHandlePoint(elementId, handleKey, x, y);
                  },
                  selectedAnchorId: widget.selectedElementId != null
                      ? _selectedAnchorId
                      : null,
                  selectedHandleId: widget.selectedElementId != null
                      ? _selectedHandleId
                      : null,
                ),
              ),
            ),
          ),
          Container(
            width: 280,
            color: Colors.grey.shade50,
            child: Column(
              children: [
                Expanded(
                  child: _LayerPanel(
                    layers: _layers,
                    selectedLayerId: _selectedLayerId,
                    onLayerSelected: (layerId) {
                      setState(() {
                        _selectedLayerId = layerId;
                      });
                    },
                    onLayerAdded: () => _addLayer(),
                    onLayerDeleted: (layerId) => _deleteLayer(layerId),
                    onLayerDuplicated: (layerId) => _duplicateLayer(layerId),
                    onLayerRenamed: (layerId, newName) =>
                        _renameLayer(layerId, newName),
                    onLayerVisibilityChanged: (layerId, visible) =>
                        _toggleLayerVisibility(layerId, visible),
                    onLayerLockChanged: (layerId, locked) =>
                        _toggleLayerLock(layerId, locked),
                    onLayerReordered: (oldIndex, newIndex) =>
                        _reorderLayers(oldIndex, newIndex),
                  ),
                ),
                if (widget.selectedElementId != null) ...[
                  const Divider(height: 1),
                  Expanded(
                    child: _PropertiesPanel(
                      element: widget.canvas.elements.firstWhere(
                        (e) => e.id == widget.selectedElementId,
                      ),
                      onUpdate: (element) {
                        context.read<SvgBloc>().add(SvgElementUpdated(element));
                      },
                      onDelete: () {
                        context.read<SvgBloc>().add(
                          SvgElementDeleted(widget.selectedElementId!),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addElement(BuildContext context, String type) {
    double defaultWidth = 80;
    double defaultHeight = 80;
    Map<String, dynamic> defaultAttrs = {};

    switch (type) {
      case 'rect':
        defaultAttrs = {
          'fill': '#3498db',
          'stroke': '#2980b9',
          'strokeWidth': 2,
        };
        break;
      case 'circle':
        defaultAttrs = {'fill': '#e74c3c'};
        defaultWidth = 80;
        defaultHeight = 80;
        break;
      case 'text':
        defaultAttrs = {'fill': '#2c3e50', 'fontSize': 24, 'text': 'Text'};
        defaultWidth = 100;
        defaultHeight = 30;
        break;
    }

    final element = SvgElementModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      x: 50,
      y: 50,
      width: defaultWidth,
      height: defaultHeight,
      attributes: defaultAttrs,
    );

    context.read<SvgBloc>().add(SvgElementAdded(element));
  }

  void _finishPenDrawing(BuildContext context) {
    if (_currentTool == SvgTool.penBezier) {
      _finishBezierDrawing(context);
      return;
    }

    if (_currentPath.length < 2) {
      setState(() {
        _currentPath = [];
        _drawingElementId = null;
      });
      return;
    }

    double minX = _currentPath.first.x;
    double minY = _currentPath.first.y;
    double maxX = _currentPath.first.x;
    double maxY = _currentPath.first.y;

    for (final point in _currentPath) {
      if (point.x < minX) minX = point.x;
      if (point.y < minY) minY = point.y;
      if (point.x > maxX) maxX = point.x;
      if (point.y > maxY) maxY = point.y;
    }

    final element = SvgElementModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'path',
      x: minX,
      y: minY,
      width: maxX - minX,
      height: maxY - minY,
      attributes: {'fill': 'none', 'stroke': '#e74c3c', 'strokeWidth': 2},
      points: List.from(_currentPath),
    );

    context.read<SvgBloc>().add(SvgElementAdded(element));

    setState(() {
      _currentPath = [];
      _drawingElementId = null;
    });
  }

  void _finishBezierDrawing(BuildContext context) {
    if (_currentAnchorPoints.length < 2) {
      setState(() {
        _currentAnchorPoints = [];
        _drawingElementId = null;
      });
      return;
    }

    double minX = _currentAnchorPoints.first.x;
    double minY = _currentAnchorPoints.first.y;
    double maxX = _currentAnchorPoints.first.x;
    double maxY = _currentAnchorPoints.first.y;

    for (final point in _currentAnchorPoints) {
      if (point.x < minX) minX = point.x;
      if (point.y < minY) minY = point.y;
      if (point.x > maxX) maxX = point.x;
      if (point.y > maxY) maxY = point.y;
    }

    final element = SvgElementModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'path',
      x: minX,
      y: minY,
      width: maxX - minX,
      height: maxY - minY,
      attributes: {'fill': 'none', 'stroke': '#3498db', 'strokeWidth': 2},
      anchorPoints: List.from(_currentAnchorPoints),
    );

    context.read<SvgBloc>().add(SvgElementAdded(element));

    setState(() {
      _currentAnchorPoints = [];
      _drawingElementId = null;
    });
  }

  void _updateAnchorPoint(String elementId, SvgAnchorPoint updatedAnchor) {
    final elementIndex = widget.canvas.elements.indexWhere(
      (e) => e.id == elementId,
    );
    if (elementIndex == -1) return;

    final element = widget.canvas.elements[elementIndex];
    if (element.anchorPoints == null) return;

    final newAnchorPoints = element.anchorPoints!.map((anchor) {
      return anchor.id == updatedAnchor.id ? updatedAnchor : anchor;
    }).toList();

    final updatedElement = element.copyWith(anchorPoints: newAnchorPoints);
    context.read<SvgBloc>().add(SvgElementUpdated(updatedElement));

    setState(() {
      _selectedAnchorId = updatedAnchor.id;
    });
  }

  void _updateHandlePoint(
    String elementId,
    String handleKey,
    double x,
    double y,
  ) {
    final elementIndex = widget.canvas.elements.indexWhere(
      (e) => e.id == elementId,
    );
    if (elementIndex == -1) return;

    final element = widget.canvas.elements[elementIndex];
    if (element.anchorPoints == null) return;

    final newAnchorPoints = element.anchorPoints!.map((anchor) {
      if (anchor.id == _selectedAnchorId) {
        if (handleKey == 'handleIn') {
          return anchor.copyWith(
            handleIn: SvgControlPoint(x: x, y: y),
          );
        } else if (handleKey == 'handleOut') {
          return anchor.copyWith(
            handleOut: SvgControlPoint(x: x, y: y),
          );
        }
      }
      return anchor;
    }).toList();

    final updatedElement = element.copyWith(anchorPoints: newAnchorPoints);
    context.read<SvgBloc>().add(SvgElementUpdated(updatedElement));

    setState(() {
      _selectedHandleId = '${handleKey}_$_selectedAnchorId';
    });
  }

  void _addLayer() {
    final newLayer = SvgLayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Layer ${_layers.length + 1}',
      visible: true,
      locked: false,
      elements: [],
    );
    final updatedLayers = [..._layers, newLayer];
    context.read<SvgBloc>().add(
      SvgCanvasUpdated(widget.canvas.copyWith(layers: updatedLayers)),
    );
    setState(() {
      _selectedLayerId = newLayer.id;
    });
  }

  void _deleteLayer(String layerId) {
    if (_layers.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete the last layer')),
      );
      return;
    }
    final updatedLayers = _layers.where((l) => l.id != layerId).toList();
    context.read<SvgBloc>().add(
      SvgCanvasUpdated(widget.canvas.copyWith(layers: updatedLayers)),
    );
    setState(() {
      if (_selectedLayerId == layerId) {
        _selectedLayerId = updatedLayers.isNotEmpty
            ? updatedLayers.first.id
            : null;
      }
    });
  }

  void _duplicateLayer(String layerId) {
    final layer = _layers.firstWhere((l) => l.id == layerId);
    final duplicatedLayer = SvgLayerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${layer.name} Copy',
      visible: layer.visible,
      locked: false,
      elements: layer.elements
          .map(
            (e) => e.copyWith(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
            ),
          )
          .toList(),
    );
    final updatedLayers = [..._layers, duplicatedLayer];
    context.read<SvgBloc>().add(
      SvgCanvasUpdated(widget.canvas.copyWith(layers: updatedLayers)),
    );
    setState(() {
      _selectedLayerId = duplicatedLayer.id;
    });
  }

  void _renameLayer(String layerId, String newName) {
    final updatedLayers = _layers.map((l) {
      return l.id == layerId ? l.copyWith(name: newName) : l;
    }).toList();
    context.read<SvgBloc>().add(
      SvgCanvasUpdated(widget.canvas.copyWith(layers: updatedLayers)),
    );
  }

  void _toggleLayerVisibility(String layerId, bool visible) {
    final updatedLayers = _layers.map((l) {
      return l.id == layerId ? l.copyWith(visible: visible) : l;
    }).toList();
    context.read<SvgBloc>().add(
      SvgCanvasUpdated(widget.canvas.copyWith(layers: updatedLayers)),
    );
  }

  void _toggleLayerLock(String layerId, bool locked) {
    final updatedLayers = _layers.map((l) {
      return l.id == layerId ? l.copyWith(locked: locked) : l;
    }).toList();
    context.read<SvgBloc>().add(
      SvgCanvasUpdated(widget.canvas.copyWith(layers: updatedLayers)),
    );
  }

  void _reorderLayers(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final updatedLayers = List<SvgLayerModel>.from(_layers);
    final layer = updatedLayers.removeAt(oldIndex);
    updatedLayers.insert(newIndex, layer);
    context.read<SvgBloc>().add(
      SvgCanvasUpdated(widget.canvas.copyWith(layers: updatedLayers)),
    );
  }
}

class _ToolPanel extends StatelessWidget {
  final SvgTool currentTool;
  final Function(SvgTool) onToolSelected;
  final Function(String) onAddElement;

  const _ToolPanel({
    required this.currentTool,
    required this.onToolSelected,
    required this.onAddElement,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tools',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(),
          _ToolButton(
            icon: Icons.near_me,
            label: 'Select',
            isSelected: currentTool == SvgTool.select,
            onTap: () => onToolSelected(SvgTool.select),
          ),
          _ToolButton(
            icon: Icons.edit,
            label: 'Pen (Free draw)',
            isSelected: currentTool == SvgTool.pen,
            onTap: () => onToolSelected(SvgTool.pen),
          ),
          _ToolButton(
            icon: Icons.gesture,
            label: 'Pen (Bezier)',
            isSelected: currentTool == SvgTool.penBezier,
            onTap: () => onToolSelected(SvgTool.penBezier),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Elements',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          _ToolButton(
            icon: Icons.crop_square,
            label: 'Rectangle',
            onTap: () => onAddElement('rect'),
          ),
          _ToolButton(
            icon: Icons.circle_outlined,
            label: 'Circle',
            onTap: () => onAddElement('circle'),
          ),
          _ToolButton(
            icon: Icons.text_fields,
            label: 'Text',
            onTap: () => onAddElement('text'),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  const _ToolButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}

class _LayerPanel extends StatelessWidget {
  final List<SvgLayerModel> layers;
  final String? selectedLayerId;
  final Function(String) onLayerSelected;
  final VoidCallback onLayerAdded;
  final Function(String) onLayerDeleted;
  final Function(String) onLayerDuplicated;
  final Function(String, String) onLayerRenamed;
  final Function(String, bool) onLayerVisibilityChanged;
  final Function(String, bool) onLayerLockChanged;
  final Function(int, int) onLayerReordered;

  const _LayerPanel({
    required this.layers,
    required this.selectedLayerId,
    required this.onLayerSelected,
    required this.onLayerAdded,
    required this.onLayerDeleted,
    required this.onLayerDuplicated,
    required this.onLayerRenamed,
    required this.onLayerVisibilityChanged,
    required this.onLayerLockChanged,
    required this.onLayerReordered,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              const Text(
                'Layers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: onLayerAdded,
                tooltip: 'Add Layer',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        Expanded(
          child: layers.isEmpty
              ? const Center(
                  child: Text(
                    'No layers',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ReorderableListView.builder(
                  itemCount: layers.length,
                  onReorder: onLayerReordered,
                  itemBuilder: (context, index) {
                    final layer = layers[index];
                    return _LayerItem(
                      key: ValueKey(layer.id),
                      layer: layer,
                      isSelected: layer.id == selectedLayerId,
                      onTap: () => onLayerSelected(layer.id),
                      onVisibilityChanged: (v) =>
                          onLayerVisibilityChanged(layer.id, v),
                      onLockChanged: (v) => onLayerLockChanged(layer.id, v),
                      onRename: (n) => onLayerRenamed(layer.id, n),
                      onDuplicate: () => onLayerDuplicated(layer.id),
                      onDelete: () => onLayerDeleted(layer.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _LayerItem extends StatefulWidget {
  final SvgLayerModel layer;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(bool) onVisibilityChanged;
  final Function(bool) onLockChanged;
  final Function(String) onRename;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const _LayerItem({
    super.key,
    required this.layer,
    required this.isSelected,
    required this.onTap,
    required this.onVisibilityChanged,
    required this.onLockChanged,
    required this.onRename,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  State<_LayerItem> createState() => _LayerItemState();
}

class _LayerItemState extends State<_LayerItem> {
  bool _isEditing = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.layer.name);
  }

  @override
  void didUpdateWidget(covariant _LayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layer.name != widget.layer.name) {
      _nameController.text = widget.layer.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startRename() {
    setState(() {
      _isEditing = true;
    });
  }

  void _finishRename() {
    setState(() {
      _isEditing = false;
    });
    if (_nameController.text.trim().isNotEmpty) {
      widget.onRename(_nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : null,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.drag_handle, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  widget.layer.visible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  size: 18,
                  color: widget.layer.visible ? Colors.black54 : Colors.grey,
                ),
                onPressed: () =>
                    widget.onVisibilityChanged(!widget.layer.visible),
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                padding: EdgeInsets.zero,
                tooltip: widget.layer.visible ? 'Hide Layer' : 'Show Layer',
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _nameController,
                        autofocus: true,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _finishRename(),
                        onEditingComplete: _finishRename,
                      )
                    : Text(
                        widget.layer.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.layer.visible
                              ? Colors.black87
                              : Colors.grey,
                          decoration: widget.layer.visible
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              IconButton(
                icon: Icon(
                  widget.layer.locked ? Icons.lock : Icons.lock_open,
                  size: 18,
                  color: widget.layer.locked ? Colors.orange : Colors.grey,
                ),
                onPressed: () => widget.onLockChanged(!widget.layer.locked),
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                padding: EdgeInsets.zero,
                tooltip: widget.layer.locked ? 'Unlock Layer' : 'Lock Layer',
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'rename':
                      _startRename();
                      break;
                    case 'duplicate':
                      widget.onDuplicate();
                      break;
                    case 'delete':
                      widget.onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Rename'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 18),
                        SizedBox(width: 8),
                        Text('Duplicate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SvgCanvas extends StatelessWidget {
  final SvgCanvasModel canvas;
  final String? selectedElementId;
  final SvgTool currentTool;
  final List<SvgPoint> currentPath;
  final List<SvgAnchorPoint> currentAnchorPoints;
  final String? drawingElementId;
  final String? selectedAnchorId;
  final String? selectedHandleId;
  final Function(String?) onElementSelected;
  final Function(String, double, double) onElementMoved;
  final Function(String, SvgAnchorPoint) onAnchorPointMoved;
  final Function(String, String, double, double) onHandleMoved;
  final Function(SvgPoint) onPenPointAdded;
  final VoidCallback onPenDrawingComplete;
  final Function(String) onPenDrawingStarted;

  const _SvgCanvas({
    required this.canvas,
    this.selectedElementId,
    required this.currentTool,
    required this.currentPath,
    this.currentAnchorPoints = const [],
    this.drawingElementId,
    this.selectedAnchorId,
    this.selectedHandleId,
    required this.onElementSelected,
    required this.onElementMoved,
    required this.onAnchorPointMoved,
    required this.onHandleMoved,
    required this.onPenPointAdded,
    required this.onPenDrawingComplete,
    required this.onPenDrawingStarted,
  });

  @override
  Widget build(BuildContext context) {
    final isPenTool =
        currentTool == SvgTool.pen || currentTool == SvgTool.penBezier;
    return GestureDetector(
      onTapUp: currentTool == SvgTool.penBezier
          ? (details) {
              final localPosition = details.localPosition;
              onPenPointAdded(
                SvgPoint(x: localPosition.dx, y: localPosition.dy),
              );
            }
          : null,
      onPanStart: isPenTool
          ? (details) {
              final elementId = DateTime.now().millisecondsSinceEpoch
                  .toString();
              onPenDrawingStarted(elementId);
              final localPosition = details.localPosition;
              onPenPointAdded(
                SvgPoint(x: localPosition.dx, y: localPosition.dy),
              );
            }
          : null,
      onPanUpdate: isPenTool && currentTool == SvgTool.pen
          ? (details) {
              final localPosition = details.localPosition;
              onPenPointAdded(
                SvgPoint(x: localPosition.dx, y: localPosition.dy),
              );
            }
          : null,
      onPanEnd: isPenTool && currentTool == SvgTool.pen
          ? (details) {
              onPenDrawingComplete();
            }
          : null,
      onTap: currentTool == SvgTool.select
          ? () => onElementSelected(null)
          : null,
      child: Container(
        width: canvas.width,
        height: canvas.height,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _SvgBackgroundPainter(),
          child: Stack(
            children: [
              ...canvas.elements.map((element) {
                return _SvgElementWidget(
                  key: ValueKey(element.id),
                  element: element,
                  isSelected: element.id == selectedElementId,
                  isDrawing: element.id == drawingElementId,
                  currentTool: currentTool,
                  onTap: currentTool == SvgTool.select
                      ? () => onElementSelected(element.id)
                      : null,
                  onDrag: currentTool == SvgTool.select
                      ? (dx, dy) {
                          onElementMoved(
                            element.id,
                            element.x + dx,
                            element.y + dy,
                          );
                        }
                      : null,
                  onAnchorPointMoved: currentTool == SvgTool.select
                      ? (elementId, anchor) =>
                            onAnchorPointMoved(elementId, anchor)
                      : null,
                  onHandleMoved: currentTool == SvgTool.select
                      ? (elementId, handleKey, x, y) =>
                            onHandleMoved(elementId, handleKey, x, y)
                      : null,
                  selectedAnchorId: selectedElementId == element.id
                      ? selectedAnchorId
                      : null,
                  selectedHandleId: selectedElementId == element.id
                      ? selectedHandleId
                      : null,
                );
              }),
              if (currentPath.isNotEmpty)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PathPreviewPainter(points: currentPath),
                  ),
                ),
              if (currentAnchorPoints.isNotEmpty)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BezierAnchorPreviewPainter(
                      points: currentAnchorPoints,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SvgBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    const gridSize = 20.0;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PathPreviewPainter extends CustomPainter {
  final List<SvgPoint> points;

  _PathPreviewPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = const Color(0xFFe74c3c)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.x, points.first.y);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PathPreviewPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _BezierAnchorPreviewPainter extends CustomPainter {
  final List<SvgAnchorPoint> points;

  _BezierAnchorPreviewPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final anchorPaint = Paint()
      ..color = const Color(0xFF3498db)
      ..style = PaintingStyle.fill;

    final handlePaint = Paint()
      ..color = const Color(0xFFe74c3c)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final pathPaint = Paint()
      ..color = const Color(0xFF3498db)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.x, points.first.y);
      for (int i = 1; i < points.length; i++) {
        final p1 = points[i - 1];
        final p2 = points[i];

        if (p1.handleOut != null && p2.handleIn != null) {
          path.cubicTo(
            p1.handleOut!.x,
            p1.handleOut!.y,
            p2.handleIn!.x,
            p2.handleIn!.y,
            p2.x,
            p2.y,
          );
        } else if (p1.handleOut != null) {
          path.quadraticBezierTo(p1.handleOut!.x, p1.handleOut!.y, p2.x, p2.y);
        } else if (p2.handleIn != null) {
          path.quadraticBezierTo(p2.handleIn!.x, p2.handleIn!.y, p2.x, p2.y);
        } else {
          path.lineTo(p2.x, p2.y);
        }
      }
    }

    canvas.drawPath(path, pathPaint);

    for (final point in points) {
      canvas.drawCircle(Offset(point.x, point.y), 6, anchorPaint);

      if (point.handleIn != null) {
        canvas.drawLine(
          Offset(point.x, point.y),
          Offset(point.handleIn!.x, point.handleIn!.y),
          handlePaint,
        );
        canvas.drawCircle(
          Offset(point.handleIn!.x, point.handleIn!.y),
          4,
          anchorPaint..color = const Color(0xFFe74c3c),
        );
      }

      if (point.handleOut != null) {
        canvas.drawLine(
          Offset(point.x, point.y),
          Offset(point.handleOut!.x, point.handleOut!.y),
          handlePaint,
        );
        canvas.drawCircle(
          Offset(point.handleOut!.x, point.handleOut!.y),
          4,
          anchorPaint..color = const Color(0xFFe74c3c),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BezierAnchorPreviewPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _SvgElementWidget extends StatelessWidget {
  final SvgElementModel element;
  final bool isSelected;
  final bool isDrawing;
  final SvgTool currentTool;
  final VoidCallback? onTap;
  final Function(double, double)? onDrag;
  final Function(String, SvgAnchorPoint)? onAnchorPointMoved;
  final Function(String, String, double, double)? onHandleMoved;
  final String? selectedAnchorId;
  final String? selectedHandleId;

  const _SvgElementWidget({
    super.key,
    required this.element,
    required this.isSelected,
    this.isDrawing = false,
    required this.currentTool,
    this.onTap,
    this.onDrag,
    this.onAnchorPointMoved,
    this.onHandleMoved,
    this.selectedAnchorId,
    this.selectedHandleId,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnchorPoints =
        element.type == 'path' && element.anchorPoints != null;

    if (hasAnchorPoints) {
      return Positioned.fill(
        child: Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              onPanUpdate: onDrag != null
                  ? (details) => onDrag!(details.delta.dx, details.delta.dy)
                  : null,
              child: CustomPaint(
                painter: _SvgBezierPathPainter(
                  anchorPoints: element.anchorPoints!,
                  strokeColor: element.attributes['stroke'] ?? '#3498db',
                  strokeWidth:
                      (element.attributes['strokeWidth'] as num?)?.toDouble() ??
                      2.0,
                  fillColor: element.attributes['fill'],
                  isSelected: isSelected,
                ),
              ),
            ),
            if (isSelected)
              Positioned.fill(
                child: _BezierEditor(
                  anchorPoints: element.anchorPoints!,
                  onAnchorMoved: onAnchorPointMoved,
                  onHandleMoved: onHandleMoved,
                  selectedAnchorId: selectedAnchorId,
                  selectedHandleId: selectedHandleId,
                ),
              ),
          ],
        ),
      );
    }

    if (element.type == 'path' && element.points != null) {
      return Positioned.fill(
        child: GestureDetector(
          onTap: onTap,
          onPanUpdate: onDrag != null
              ? (details) => onDrag!(details.delta.dx, details.delta.dy)
              : null,
          child: CustomPaint(
            painter: _SvgPathPainter(
              points: element.points!,
              strokeColor: element.attributes['stroke'] ?? '#e74c3c',
              strokeWidth:
                  (element.attributes['strokeWidth'] as num?)?.toDouble() ??
                  2.0,
              fillColor: element.attributes['fill'],
              isSelected: isSelected,
            ),
          ),
        ),
      );
    }

    return Positioned(
      left: element.x,
      top: element.y,
      child: GestureDetector(
        onTap: onTap,
        onPanUpdate: onDrag != null
            ? (details) => onDrag!(details.delta.dx, details.delta.dy)
            : null,
        child: Container(
          width: element.width,
          height: element.height,
          decoration: BoxDecoration(
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: _buildElement(),
        ),
      ),
    );
  }

  Widget _buildElement() {
    switch (element.type) {
      case 'rect':
        return Container(
          decoration: BoxDecoration(
            color: _parseColor(element.attributes['fill'], '0xFF3498db'),
            border: element.attributes['strokeWidth'] != null
                ? Border.all(
                    color: _parseColor(
                      element.attributes['stroke'],
                      '0xFF2980b9',
                    ),
                    width: (element.attributes['strokeWidth'] as num)
                        .toDouble(),
                  )
                : null,
          ),
        );
      case 'circle':
        return Center(
          child: Container(
            width: element.width,
            height: element.height,
            decoration: BoxDecoration(
              color: _parseColor(element.attributes['fill'], '0xFFe74c3c'),
              shape: BoxShape.circle,
            ),
          ),
        );
      case 'text':
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            element.attributes['text']?.toString() ?? 'Text',
            style: TextStyle(
              color: _parseColor(element.attributes['fill'], '0xFF2c3e50'),
              fontSize:
                  (element.attributes['fontSize'] as num?)?.toDouble() ?? 24,
            ),
          ),
        );
      default:
        return Container(color: Colors.grey);
    }
  }

  Color _parseColor(String? colorStr, String defaultColor) {
    if (colorStr == null || colorStr.isEmpty) {
      return Color(int.parse(defaultColor));
    }
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Color(int.parse(defaultColor));
    }
  }
}

class _SvgPathPainter extends CustomPainter {
  final List<SvgPoint> points;
  final String strokeColor;
  final double strokeWidth;
  final String? fillColor;
  final bool isSelected;

  _SvgPathPainter({
    required this.points,
    required this.strokeColor,
    required this.strokeWidth,
    this.fillColor,
    this.isSelected = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    Color strokeColorParsed;
    try {
      strokeColorParsed = Color(
        int.parse(strokeColor.replaceFirst('#', '0xFF')),
      );
    } catch (_) {
      strokeColorParsed = const Color(0xFFe74c3c);
    }

    final paint = Paint()
      ..color = strokeColorParsed
      ..strokeWidth = strokeWidth
      ..style = fillColor != null && fillColor != 'none'
          ? PaintingStyle.fill
          : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (fillColor != null && fillColor != 'none') {
      Color fillColorParsed;
      try {
        fillColorParsed = Color(
          int.parse(fillColor!.replaceFirst('#', '0xFF')),
        );
      } catch (_) {
        fillColorParsed = Colors.transparent;
      }
      paint.color = fillColorParsed;
    }

    final path = Path()..moveTo(points.first.x, points.first.y);

    if (points.length == 2) {
      path.lineTo(points[1].x, points[1].y);
    } else {
      for (int i = 1; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];

        final midX = (p1.x + p2.x) / 2;
        final midY = (p1.y + p2.y) / 2;

        path.quadraticBezierTo(p1.x, p1.y, midX, midY);
      }

      path.lineTo(points.last.x, points.last.y);
    }

    canvas.drawPath(path, paint);

    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, selectionPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SvgPathPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.isSelected != isSelected;
  }
}

class _SvgBezierPathPainter extends CustomPainter {
  final List<SvgAnchorPoint> anchorPoints;
  final String strokeColor;
  final double strokeWidth;
  final String? fillColor;
  final bool isSelected;

  _SvgBezierPathPainter({
    required this.anchorPoints,
    required this.strokeColor,
    required this.strokeWidth,
    this.fillColor,
    this.isSelected = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (anchorPoints.length < 2) return;

    Color strokeColorParsed;
    try {
      strokeColorParsed = Color(
        int.parse(strokeColor.replaceFirst('#', '0xFF')),
      );
    } catch (_) {
      strokeColorParsed = const Color(0xFF3498db);
    }

    final paint = Paint()
      ..color = strokeColorParsed
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(anchorPoints.first.x, anchorPoints.first.y);

    for (int i = 1; i < anchorPoints.length; i++) {
      final p1 = anchorPoints[i - 1];
      final p2 = anchorPoints[i];

      if (p1.handleOut != null && p2.handleIn != null) {
        path.cubicTo(
          p1.handleOut!.x,
          p1.handleOut!.y,
          p2.handleIn!.x,
          p2.handleIn!.y,
          p2.x,
          p2.y,
        );
      } else if (p1.handleOut != null) {
        path.quadraticBezierTo(p1.handleOut!.x, p1.handleOut!.y, p2.x, p2.y);
      } else if (p2.handleIn != null) {
        path.quadraticBezierTo(p2.handleIn!.x, p2.handleIn!.y, p2.x, p2.y);
      } else {
        path.lineTo(p2.x, p2.y);
      }
    }

    canvas.drawPath(path, paint);

    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, selectionPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SvgBezierPathPainter oldDelegate) {
    return oldDelegate.anchorPoints != anchorPoints ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.isSelected != isSelected;
  }
}

class _BezierEditor extends StatelessWidget {
  final List<SvgAnchorPoint> anchorPoints;
  final Function(String, SvgAnchorPoint)? onAnchorMoved;
  final Function(String, String, double, double)? onHandleMoved;
  final String? selectedAnchorId;
  final String? selectedHandleId;

  const _BezierEditor({
    required this.anchorPoints,
    this.onAnchorMoved,
    this.onHandleMoved,
    this.selectedAnchorId,
    this.selectedHandleId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final anchor in anchorPoints) ...[
          if (anchor.handleIn != null)
            _HandleWidget(
              anchorId: anchor.id,
              handleKey: 'handleIn',
              position: anchor.handleIn!,
              onDrag: onHandleMoved != null
                  ? (dx, dy) => onHandleMoved!(
                      anchor.id,
                      'handleIn',
                      anchor.handleIn!.x + dx,
                      anchor.handleIn!.y + dy,
                    )
                  : null,
              isSelected: selectedHandleId == 'handleIn_${anchor.id}',
            ),
          if (anchor.handleOut != null)
            _HandleWidget(
              anchorId: anchor.id,
              handleKey: 'handleOut',
              position: anchor.handleOut!,
              onDrag: onHandleMoved != null
                  ? (dx, dy) => onHandleMoved!(
                      anchor.id,
                      'handleOut',
                      anchor.handleOut!.x + dx,
                      anchor.handleOut!.y + dy,
                    )
                  : null,
              isSelected: selectedHandleId == 'handleOut_${anchor.id}',
            ),
          _AnchorWidget(
            anchor: anchor,
            onDrag: onAnchorMoved != null
                ? (dx, dy) => onAnchorMoved!(
                    anchor.id,
                    anchor.copyWith(x: anchor.x + dx, y: anchor.y + dy),
                  )
                : null,
            isSelected: selectedAnchorId == anchor.id,
          ),
        ],
      ],
    );
  }
}

class _AnchorWidget extends StatelessWidget {
  final SvgAnchorPoint anchor;
  final Function(double, double)? onDrag;
  final bool isSelected;

  const _AnchorWidget({
    required this.anchor,
    this.onDrag,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: anchor.x - 8,
      top: anchor.y - 8,
      child: GestureDetector(
        onPanUpdate: onDrag != null
            ? (details) => onDrag!(details.delta.dx, details.delta.dy)
            : null,
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            border: Border.all(color: Colors.blue, width: 2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _HandleWidget extends StatelessWidget {
  final String anchorId;
  final String handleKey;
  final SvgControlPoint position;
  final Function(double, double)? onDrag;
  final bool isSelected;

  const _HandleWidget({
    required this.anchorId,
    required this.handleKey,
    required this.position,
    this.onDrag,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.x - 4,
      top: position.y - 4,
      child: GestureDetector(
        onPanUpdate: onDrag != null
            ? (details) => onDrag!(details.delta.dx, details.delta.dy)
            : null,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : const Color(0xFFe74c3c),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _PropertiesPanel extends StatefulWidget {
  final SvgElementModel element;
  final Function(SvgElementModel) onUpdate;
  final VoidCallback onDelete;

  const _PropertiesPanel({
    required this.element,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_PropertiesPanel> createState() => _PropertiesPanelState();
}

class _PropertiesPanelState extends State<_PropertiesPanel> {
  late TextEditingController _xController;
  late TextEditingController _yController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _xController = TextEditingController(text: widget.element.x.toString());
    _yController = TextEditingController(text: widget.element.y.toString());
    _widthController = TextEditingController(
      text: widget.element.width.toString(),
    );
    _heightController = TextEditingController(
      text: widget.element.height.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _PropertiesPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element.id != widget.element.id) {
      _xController.text = widget.element.x.toString();
      _yController.text = widget.element.y.toString();
      _widthController.text = widget.element.width.toString();
      _heightController.text = widget.element.height.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Properties',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          Text('Type: ${widget.element.type.toUpperCase()}'),
          const SizedBox(height: 16),
          if (widget.element.type != 'path') ...[
            const Text(
              'Position',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _xController,
                    decoration: const InputDecoration(labelText: 'X'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _updateProperty('x', double.tryParse(v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _yController,
                    decoration: const InputDecoration(labelText: 'Y'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _updateProperty('y', double.tryParse(v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(labelText: 'Width'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        _updateProperty('width', double.tryParse(v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    decoration: const InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        _updateProperty('height', double.tryParse(v)),
                  ),
                ),
              ],
            ),
          ],
          if (widget.element.anchorPoints != null &&
              widget.element.anchorPoints!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Anchor Points',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...widget.element.anchorPoints!.asMap().entries.map((entry) {
              final index = entry.key;
              final anchor = entry.value;
              return Card(
                child: ListTile(
                  dense: true,
                  title: Text('Point ${index + 1}'),
                  subtitle: Text(
                    'Type: ${anchor.type.name} (${anchor.x.toStringAsFixed(1)}, ${anchor.y.toStringAsFixed(1)})',
                  ),
                  trailing: PopupMenuButton<SvgAnchorType>(
                    icon: const Icon(Icons.edit),
                    onSelected: (type) =>
                        _updateAnchorType(index, anchor, type),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: SvgAnchorType.corner,
                        child: Text('Corner'),
                      ),
                      const PopupMenuItem(
                        value: SvgAnchorType.smooth,
                        child: Text('Smooth'),
                      ),
                      const PopupMenuItem(
                        value: SvgAnchorType.symmetric,
                        child: Text('Symmetric'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          if (widget.element.attributes.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Style', style: TextStyle(fontWeight: FontWeight.w600)),
            ...widget.element.attributes.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  decoration: InputDecoration(labelText: e.key, isDense: true),
                  controller: TextEditingController(text: e.value.toString()),
                  onChanged: (v) {
                    final attrs = Map<String, dynamic>.from(
                      widget.element.attributes,
                    );
                    attrs[e.key] = v;
                    widget.onUpdate(widget.element.copyWith(attributes: attrs));
                  },
                ),
              );
            }),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: widget.onDelete,
              child: const Text('Delete Element'),
            ),
          ),
        ],
      ),
    );
  }

  void _updateProperty(String prop, double? value) {
    if (value == null) return;
    widget.onUpdate(
      widget.element.copyWith(
        x: prop == 'x' ? value : null,
        y: prop == 'y' ? value : null,
        width: prop == 'width' ? value : null,
        height: prop == 'height' ? value : null,
      ),
    );
  }

  void _updateAnchorType(int index, SvgAnchorPoint anchor, SvgAnchorType type) {
    final newAnchorPoints = List<SvgAnchorPoint>.from(
      widget.element.anchorPoints!,
    );
    SvgAnchorPoint newAnchor;

    if (type == SvgAnchorType.smooth) {
      final dx = anchor.handleOut != null
          ? anchor.handleOut!.x - anchor.x
          : 30.0;
      final dy = anchor.handleOut != null
          ? anchor.handleOut!.y - anchor.y
          : 0.0;
      newAnchor = anchor.copyWith(
        type: type,
        handleIn: SvgControlPoint(x: anchor.x - dx, y: anchor.y - dy),
        handleOut: SvgControlPoint(x: anchor.x + dx, y: anchor.y + dy),
      );
    } else if (type == SvgAnchorType.symmetric) {
      final dx = anchor.handleOut != null
          ? anchor.handleOut!.x - anchor.x
          : 30.0;
      final dy = anchor.handleOut != null
          ? anchor.handleOut!.y - anchor.y
          : 0.0;
      newAnchor = anchor.copyWith(
        type: type,
        handleIn: SvgControlPoint(x: anchor.x - dx, y: anchor.y - dy),
        handleOut: SvgControlPoint(x: anchor.x + dx, y: anchor.y + dy),
      );
    } else {
      newAnchor = anchor.copyWith(
        type: type,
        clearHandleIn: true,
        clearHandleOut: true,
      );
    }

    newAnchorPoints[index] = newAnchor;
    widget.onUpdate(widget.element.copyWith(anchorPoints: newAnchorPoints));
  }
}
