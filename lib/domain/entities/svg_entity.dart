import 'package:equatable/equatable.dart';

/// SVG anchor type enumeration
enum SvgAnchorType { corner, smooth, symmetric }

/// SVG control point
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

/// SVG anchor point
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

/// SVG point
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

/// SVG element
class SvgElement extends Equatable {
  final String id;
  final String type;
  final double x;
  final double y;
  final double width;
  final double height;
  final Map<String, dynamic> attributes;
  final List<SvgPoint>? points;
  final List<SvgAnchorPoint>? anchorPoints;

  const SvgElement({
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

  SvgElement copyWith({
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
    return SvgElement(
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

/// SVG layer
class SvgLayer extends Equatable {
  final String id;
  final String name;
  final bool visible;
  final bool locked;
  final List<SvgElement> elements;

  const SvgLayer({
    required this.id,
    required this.name,
    this.visible = true,
    this.locked = false,
    this.elements = const [],
  });

  SvgLayer copyWith({
    String? id,
    String? name,
    bool? visible,
    bool? locked,
    List<SvgElement>? elements,
  }) {
    return SvgLayer(
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

/// SVG canvas
class SvgCanvas extends Equatable {
  final String id;
  final String name;
  final double width;
  final double height;
  final List<SvgElement> elements;
  final List<SvgLayer> layers;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SvgCanvas({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    this.elements = const [],
    this.layers = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  SvgCanvas copyWith({
    String? id,
    String? name,
    double? width,
    double? height,
    List<SvgElement>? elements,
    List<SvgLayer>? layers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SvgCanvas(
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
