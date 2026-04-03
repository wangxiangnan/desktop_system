import '../models/svg_model.dart';
import 'svg_repository.dart';
import '../../services/svg_service.dart';

class SvgRepositoryImpl implements SvgRepository {
  final SvgService? _svgService;
  final List<SvgCanvasModel> _canvases = [];

  SvgRepositoryImpl({SvgService? svgService}) : _svgService = svgService {
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    _canvases.addAll([
      SvgCanvasModel(
        id: '1',
        name: 'Logo Design',
        width: 200,
        height: 200,
        elements: [
          const SvgElementModel(
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
          const SvgElementModel(
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
      SvgCanvasModel(
        id: '2',
        name: 'Banner',
        width: 800,
        height: 400,
        elements: [
          const SvgElementModel(
            id: 'e3',
            type: 'rect',
            x: 0,
            y: 0,
            width: 800,
            height: 400,
            attributes: {'fill': '#2ecc71'},
          ),
          const SvgElementModel(
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

  @override
  Future<List<SvgCanvasModel>> getCanvases() async {
    if (_svgService != null) {
      return await _svgService.getCanvases();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_canvases);
  }

  @override
  Future<SvgCanvasModel> getCanvasById(String id) async {
    if (_svgService != null) {
      return await _svgService.getCanvasById(id);
    }

    await Future.delayed(const Duration(milliseconds: 200));
    return _canvases.firstWhere((c) => c.id == id);
  }

  @override
  Future<SvgCanvasModel> createCanvas(SvgCanvasModel canvas) async {
    if (_svgService != null) {
      return await _svgService.createCanvas(canvas);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    _canvases.add(canvas);
    return canvas;
  }

  @override
  Future<SvgCanvasModel> updateCanvas(SvgCanvasModel canvas) async {
    if (_svgService != null) {
      return await _svgService.updateCanvas(canvas);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    final index = _canvases.indexWhere((c) => c.id == canvas.id);
    if (index != -1) {
      _canvases[index] = canvas;
    }
    return canvas;
  }

  @override
  Future<void> deleteCanvas(String id) async {
    if (_svgService != null) {
      await _svgService.deleteCanvas(id);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    _canvases.removeWhere((c) => c.id == id);
  }
}
