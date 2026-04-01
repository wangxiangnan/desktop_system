import 'package:equatable/equatable.dart';

enum SvgAnchorType { corner, smooth, symmetric }

class SvgLayerModel extends Equatable {
  final String id;
  final String name;
  final bool visible;
  final bool locked;
  final List<SvgElementModel> elements;

  const SvgLayerModel({
    required this.id,
    required this.name,
    this.visible = true,
    this.locked = false,
    this.elements = const [],
  });

  factory SvgLayerModel.fromJson(Map<String, dynamic> json) {
    return SvgLayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      visible: json['visible'] as bool? ?? true,
      locked: json['locked'] as bool? ?? false,
      elements:
          (json['elements'] as List<dynamic>?)
              ?.map((e) => SvgElementModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'visible': visible,
      'locked': locked,
      'elements': elements.map((e) => e.toJson()).toList(),
    };
  }

  SvgLayerModel copyWith({
    String? id,
    String? name,
    bool? visible,
    bool? locked,
    List<SvgElementModel>? elements,
  }) {
    return SvgLayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      elements: elements ?? this.elements,
    );
  }

  @override
  List<Object?> get props => [id, name, visible, locked, elements];
}

class SvgControlPoint extends Equatable {
  final double x;
  final double y;

  const SvgControlPoint({required this.x, required this.y});

  factory SvgControlPoint.fromJson(Map<String, dynamic> json) {
    return SvgControlPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  @override
  List<Object?> get props => [x, y];
}

class SvgAnchorPoint extends Equatable {
  final String id;
  final double x;
  final double y;
  final SvgAnchorType type;
  final SvgControlPoint? handleIn;
  final SvgControlPoint? handleOut;

  const SvgAnchorPoint({
    required this.id,
    required this.x,
    required this.y,
    this.type = SvgAnchorType.corner,
    this.handleIn,
    this.handleOut,
  });

  factory SvgAnchorPoint.fromJson(Map<String, dynamic> json) {
    return SvgAnchorPoint(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      type: SvgAnchorType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SvgAnchorType.corner,
      ),
      handleIn: json['handleIn'] != null
          ? SvgControlPoint.fromJson(json['handleIn'] as Map<String, dynamic>)
          : null,
      handleOut: json['handleOut'] != null
          ? SvgControlPoint.fromJson(json['handleOut'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {'id': id, 'x': x, 'y': y, 'type': type.name};
    if (handleIn != null) map['handleIn'] = handleIn!.toJson();
    if (handleOut != null) map['handleOut'] = handleOut!.toJson();
    return map;
  }

  SvgAnchorPoint copyWith({
    String? id,
    double? x,
    double? y,
    SvgAnchorType? type,
    SvgControlPoint? handleIn,
    SvgControlPoint? handleOut,
    bool clearHandleIn = false,
    bool clearHandleOut = false,
  }) {
    return SvgAnchorPoint(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      type: type ?? this.type,
      handleIn: clearHandleIn ? null : (handleIn ?? this.handleIn),
      handleOut: clearHandleOut ? null : (handleOut ?? this.handleOut),
    );
  }

  @override
  List<Object?> get props => [id, x, y, type, handleIn, handleOut];
}

class SvgPoint extends Equatable {
  final double x;
  final double y;

  const SvgPoint({required this.x, required this.y});

  factory SvgPoint.fromJson(Map<String, dynamic> json) {
    return SvgPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  @override
  List<Object?> get props => [x, y];
}

class SvgElementModel extends Equatable {
  final String id;
  final String type;
  final double x;
  final double y;
  final double width;
  final double height;
  final Map<String, dynamic> attributes;
  final List<SvgPoint>? points;
  final List<SvgAnchorPoint>? anchorPoints;

  const SvgElementModel({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.attributes = const {},
    this.points,
    this.anchorPoints,
  });

  factory SvgElementModel.fromJson(Map<String, dynamic> json) {
    return SvgElementModel(
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

  Map<String, dynamic> toJson() {
    final map = {
      'id': id,
      'type': type,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'attributes': attributes,
    };
    if (points != null) {
      map['points'] = points!.map((p) => p.toJson()).toList();
    }
    if (anchorPoints != null) {
      map['anchorPoints'] = anchorPoints!.map((p) => p.toJson()).toList();
    }
    return map;
  }

  SvgElementModel copyWith({
    String? id,
    String? type,
    double? x,
    double? y,
    double? width,
    double? height,
    Map<String, dynamic>? attributes,
    List<SvgPoint>? points,
    List<SvgAnchorPoint>? anchorPoints,
  }) {
    return SvgElementModel(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      attributes: attributes ?? this.attributes,
      points: points ?? this.points,
      anchorPoints: anchorPoints ?? this.anchorPoints,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    x,
    y,
    width,
    height,
    attributes,
    points,
    anchorPoints,
  ];
}

class SvgCanvasModel extends Equatable {
  final String id;
  final String name;
  final double width;
  final double height;
  final List<SvgElementModel> elements;
  final List<SvgLayerModel> layers;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SvgCanvasModel({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    this.elements = const [],
    this.layers = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory SvgCanvasModel.fromJson(Map<String, dynamic> json) {
    return SvgCanvasModel(
      id: json['id'] as String,
      name: json['name'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      elements:
          (json['elements'] as List<dynamic>?)
              ?.map((e) => SvgElementModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      layers:
          (json['layers'] as List<dynamic>?)
              ?.map((e) => SvgLayerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'width': width,
      'height': height,
      'elements': elements.map((e) => e.toJson()).toList(),
      'layers': layers.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SvgCanvasModel copyWith({
    String? id,
    String? name,
    double? width,
    double? height,
    List<SvgElementModel>? elements,
    List<SvgLayerModel>? layers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SvgCanvasModel(
      id: id ?? this.id,
      name: name ?? this.name,
      width: width ?? this.width,
      height: height ?? this.height,
      elements: elements ?? this.elements,
      layers: layers ?? this.layers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    width,
    height,
    elements,
    layers,
    createdAt,
    updatedAt,
  ];
}
