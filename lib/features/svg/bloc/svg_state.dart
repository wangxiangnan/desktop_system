import 'package:equatable/equatable.dart';
import 'package:desktop_system/domain/entities/svg_entity.dart';

abstract class SvgState extends Equatable {
  const SvgState();

  @override
  List<Object?> get props => [];
}

class SvgInitial extends SvgState {
  const SvgInitial();
}

class SvgLoading extends SvgState {
  const SvgLoading();
}

class SvgListLoaded extends SvgState {
  final List<SvgCanvas> canvases;

  const SvgListLoaded(this.canvases);

  @override
  List<Object?> get props => [canvases];
}

class SvgEditorLoaded extends SvgState {
  final SvgCanvas canvas;
  final String? selectedElementId;

  const SvgEditorLoaded({required this.canvas, this.selectedElementId});

  SvgElement? get selectedElement {
    if (selectedElementId == null) return null;
    try {
      return canvas.elements.firstWhere((e) => e.id == selectedElementId);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [canvas, selectedElementId];
}

class SvgError extends SvgState {
  final String message;

  const SvgError(this.message);

  @override
  List<Object?> get props => [message];
}
