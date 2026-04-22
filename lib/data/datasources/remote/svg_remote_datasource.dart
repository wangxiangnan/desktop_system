import '../../../core/network/dio_client.dart';
import '../../../domain/entities/svg_entity.dart';

/// Remote data source for SVG canvases using Dio
class SvgRemoteDataSource {
  final DioClient _dioClient;

  SvgRemoteDataSource(this._dioClient);

  /// Fetch all canvases from API
  Future<List<SvgCanvas>> getCanvases() async {
    final response = await _dioClient.get('/canvases');
    final List<dynamic> canvasesJson = response.data['canvases'] ?? [];
    return canvasesJson
        .map((json) => _canvasFromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch canvas by ID from API
  Future<SvgCanvas> getCanvasById(String id) async {
    final response = await _dioClient.get('/canvases/$id');
    return _canvasFromJson(response.data as Map<String, dynamic>);
  }

  /// Create canvas via API
  Future<SvgCanvas> createCanvas(SvgCanvas canvas) async {
    final response = await _dioClient.post('/canvases', data: _canvasToJson(canvas));
    return _canvasFromJson(response.data as Map<String, dynamic>);
  }

  /// Update canvas via API
  Future<SvgCanvas> updateCanvas(SvgCanvas canvas) async {
    final response = await _dioClient.put(
      '/canvases/${canvas.id}',
      data: _canvasToJson(canvas),
    );
    return _canvasFromJson(response.data as Map<String, dynamic>);
  }

  /// Delete canvas via API
  Future<void> deleteCanvas(String id) async {
    await _dioClient.delete('/canvases/$id');
  }

  // JSON conversion helpers
  SvgCanvas _canvasFromJson(Map<String, dynamic> json) {
    return SvgCanvas(
      id: json['id'] as String,
      name: json['name'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      elements: (json['elements'] as List<dynamic>?)
              ?.map((e) => _elementFromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      layers: (json['layers'] as List<dynamic>?)
              ?.map((e) => _layerFromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  SvgElement _elementFromJson(Map<String, dynamic> json) {
    return SvgElement(
      id: json['id'] as String,
      type: json['type'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      attributes: json['attributes'] as Map<String, dynamic>? ?? {},
      points: (json['points'] as List<dynamic>?)
          ?.map((p) => SvgPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
      anchorPoints: (json['anchorPoints'] as List<dynamic>?)
          ?.map((p) => SvgAnchorPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  SvgLayer _layerFromJson(Map<String, dynamic> json) {
    return SvgLayer(
      id: json['id'] as String,
      name: json['name'] as String,
      visible: json['visible'] as bool? ?? true,
      locked: json['locked'] as bool? ?? false,
      elements: (json['elements'] as List<dynamic>?)
              ?.map((e) => _elementFromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> _canvasToJson(SvgCanvas canvas) {
    return {
      'id': canvas.id,
      'name': canvas.name,
      'width': canvas.width,
      'height': canvas.height,
      'elements': canvas.elements.map((e) => _elementToJson(e)).toList(),
      'layers': canvas.layers.map((l) => _layerToJson(l)).toList(),
      'created_at': canvas.createdAt.toIso8601String(),
      'updated_at': canvas.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _elementToJson(SvgElement element) {
    final map = {
      'id': element.id,
      'type': element.type,
      'x': element.x,
      'y': element.y,
      'width': element.width,
      'height': element.height,
      'attributes': element.attributes,
    };
    if (element.points != null) {
      map['points'] = element.points!.map((p) => {'x': p.x, 'y': p.y}).toList();
    }
    if (element.anchorPoints != null) {
      map['anchorPoints'] = element.anchorPoints!.map((p) => {
            'id': p.id,
            'x': p.x,
            'y': p.y,
            'type': p.type.name,
            if (p.handleIn != null) 'handleIn': {'x': p.handleIn!.x, 'y': p.handleIn!.y},
            if (p.handleOut != null) 'handleOut': {'x': p.handleOut!.x, 'y': p.handleOut!.y},
          }).toList();
    }
    return map;
  }

  Map<String, dynamic> _layerToJson(SvgLayer layer) {
    return {
      'id': layer.id,
      'name': layer.name,
      'visible': layer.visible,
      'locked': layer.locked,
      'elements': layer.elements.map((e) => _elementToJson(e)).toList(),
    };
  }
}
