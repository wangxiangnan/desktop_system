import 'package:equatable/equatable.dart';
import 'package:desktop_system/data/models/svg_model.dart';

abstract class SvgEvent extends Equatable {
  const SvgEvent();

  @override
  List<Object?> get props => [];
}

class SvgLoadRequested extends SvgEvent {
  const SvgLoadRequested();
}

class SvgCanvasSelected extends SvgEvent {
  final String canvasId;

  const SvgCanvasSelected(this.canvasId);

  @override
  List<Object?> get props => [canvasId];
}

class SvgCanvasCreated extends SvgEvent {
  final String name;
  final double width;
  final double height;

  const SvgCanvasCreated({
    required this.name,
    required this.width,
    required this.height,
  });

  @override
  List<Object?> get props => [name, width, height];
}

class SvgCanvasDeleted extends SvgEvent {
  final String canvasId;

  const SvgCanvasDeleted(this.canvasId);

  @override
  List<Object?> get props => [canvasId];
}

class SvgElementAdded extends SvgEvent {
  final SvgElementModel element;

  const SvgElementAdded(this.element);

  @override
  List<Object?> get props => [element];
}

class SvgElementUpdated extends SvgEvent {
  final SvgElementModel element;

  const SvgElementUpdated(this.element);

  @override
  List<Object?> get props => [element];
}

class SvgElementDeleted extends SvgEvent {
  final String elementId;

  const SvgElementDeleted(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class SvgElementMoved extends SvgEvent {
  final String elementId;
  final double x;
  final double y;

  const SvgElementMoved({
    required this.elementId,
    required this.x,
    required this.y,
  });

  @override
  List<Object?> get props => [elementId, x, y];
}

class SvgElementSelected extends SvgEvent {
  final String? elementId;

  const SvgElementSelected(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class SvgCanvasSaved extends SvgEvent {
  const SvgCanvasSaved();
}

class SvgCanvasUpdated extends SvgEvent {
  final SvgCanvasModel canvas;

  const SvgCanvasUpdated(this.canvas);

  @override
  List<Object?> get props => [canvas];
}
