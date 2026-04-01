import 'package:equatable/equatable.dart';
import 'package:desktop_system/data/models/svg_model.dart';

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
  final List<SvgCanvasModel> canvases;

  const SvgListLoaded(this.canvases);

  @override
  List<Object?> get props => [canvases];
}

class SvgEditorLoaded extends SvgState {
  final SvgCanvasModel canvas;
  final String? selectedElementId;

  const SvgEditorLoaded({required this.canvas, this.selectedElementId});

  SvgElementModel? get selectedElement {
    if (selectedElementId == null) return null;
    return canvas.elements.cast<SvgElementModel?>().firstWhere(
      (e) => e?.id == selectedElementId,
      orElse: () => null,
    );
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
