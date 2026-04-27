import 'package:desktop_system/domain/entities/svg_entity.dart';

/// Local data source for SVG canvases (Mock implementation)
class SvgLocalDataSource {
  final List<SvgCanvas> _canvases = [];

  SvgLocalDataSource() {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    _canvases.addAll([
      SvgCanvas(
        id: '1',
        name: 'Logo Design',
        width: 200,
        height: 200,
        elements: [
          const SvgElement(
            id: 'e1',
            type: 'rect',
            x: 50,
            y: 50,
            width: 100,
            height: 100,
            attributes: {
              'fill': '#3498db',
              'stroke': '#2980b9',
              'strokeWidth': 2,
            },
          ),
          const SvgElement(
            id: 'e2',
            type: 'circle',
            x: 100,
            y: 100,
            width: 50,
            height: 50,
            attributes: {'fill': '#e74c3c'},
          ),
        ],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      SvgCanvas(
        id: '2',
        name: 'Banner',
        width: 800,
        height: 400,
        elements: [
          const SvgElement(
            id: 'e3',
            type: 'rect',
            x: 0,
            y: 0,
            width: 800,
            height: 400,
            attributes: {'fill': '#2ecc71'},
          ),
          const SvgElement(
            id: 'e4',
            type: 'text',
            x: 400,
            y: 200,
            width: 200,
            height: 40,
            attributes: {'fill': '#ffffff', 'fontSize': 32, 'text': 'Welcome'},
          ),
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
    ]);
  }

  /// Get all canvases
  Future<List<SvgCanvas>> getCanvases() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_canvases);
  }

  /// Get canvas by ID
  Future<SvgCanvas> getCanvasById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _canvases.firstWhere((c) => c.id == id);
  }

  /// Create canvas
  Future<SvgCanvas> createCanvas(SvgCanvas canvas) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _canvases.add(canvas);
    return canvas;
  }

  /// Update canvas
  Future<SvgCanvas> updateCanvas(SvgCanvas canvas) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _canvases.indexWhere((c) => c.id == canvas.id);
    if (index != -1) {
      _canvases[index] = canvas;
    }
    return canvas;
  }

  /// Delete canvas
  Future<void> deleteCanvas(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _canvases.removeWhere((c) => c.id == id);
  }
}
