import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_system/data/repositories/svg_repository.dart';
import 'package:desktop_system/data/models/svg_model.dart';
import 'svg_event.dart';
import 'svg_state.dart';

class SvgBloc extends Bloc<SvgEvent, SvgState> {
  final SvgRepository _svgRepository;

  SvgBloc(this._svgRepository) : super(const SvgInitial()) {
    on<SvgLoadRequested>(_onLoadRequested);
    on<SvgCanvasSelected>(_onCanvasSelected);
    on<SvgCanvasCreated>(_onCanvasCreated);
    on<SvgCanvasDeleted>(_onCanvasDeleted);
    on<SvgElementAdded>(_onElementAdded);
    on<SvgElementUpdated>(_onElementUpdated);
    on<SvgElementDeleted>(_onElementDeleted);
    on<SvgElementMoved>(_onElementMoved);
    on<SvgElementSelected>(_onElementSelected);
    on<SvgCanvasSaved>(_onCanvasSaved);
    on<SvgCanvasUpdated>(_onCanvasUpdated);
  }

  Future<void> _onLoadRequested(
    SvgLoadRequested event,
    Emitter<SvgState> emit,
  ) async {
    emit(const SvgLoading());
    try {
      final canvases = await _svgRepository.getCanvases();
      emit(SvgListLoaded(canvases));
    } catch (e) {
      emit(SvgError(e.toString()));
    }
  }

  Future<void> _onCanvasSelected(
    SvgCanvasSelected event,
    Emitter<SvgState> emit,
  ) async {
    emit(const SvgLoading());
    try {
      final canvas = await _svgRepository.getCanvasById(event.canvasId);
      emit(SvgEditorLoaded(canvas: canvas));
    } catch (e) {
      emit(SvgError(e.toString()));
    }
  }

  Future<void> _onCanvasCreated(
    SvgCanvasCreated event,
    Emitter<SvgState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final canvas = SvgCanvasModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        width: event.width,
        height: event.height,
        elements: const [],
        createdAt: now,
        updatedAt: now,
      );
      await _svgRepository.createCanvas(canvas);
      add(const SvgLoadRequested());
    } catch (e) {
      emit(SvgError(e.toString()));
    }
  }

  Future<void> _onCanvasDeleted(
    SvgCanvasDeleted event,
    Emitter<SvgState> emit,
  ) async {
    try {
      await _svgRepository.deleteCanvas(event.canvasId);
      add(const SvgLoadRequested());
    } catch (e) {
      emit(SvgError(e.toString()));
    }
  }

  Future<void> _onElementAdded(
    SvgElementAdded event,
    Emitter<SvgState> emit,
  ) async {
    final currentState = state;
    if (currentState is SvgEditorLoaded) {
      final updatedElements = [...currentState.canvas.elements, event.element];
      final updatedCanvas = currentState.canvas.copyWith(
        elements: updatedElements,
        updatedAt: DateTime.now(),
      );
      emit(
        SvgEditorLoaded(
          canvas: updatedCanvas,
          selectedElementId: event.element.id,
        ),
      );
    }
  }

  Future<void> _onElementUpdated(
    SvgElementUpdated event,
    Emitter<SvgState> emit,
  ) async {
    final currentState = state;
    if (currentState is SvgEditorLoaded) {
      final updatedElements = currentState.canvas.elements.map((e) {
        return e.id == event.element.id ? event.element : e;
      }).toList();
      final updatedCanvas = currentState.canvas.copyWith(
        elements: updatedElements,
        updatedAt: DateTime.now(),
      );
      emit(
        SvgEditorLoaded(
          canvas: updatedCanvas,
          selectedElementId: currentState.selectedElementId,
        ),
      );
    }
  }

  Future<void> _onElementDeleted(
    SvgElementDeleted event,
    Emitter<SvgState> emit,
  ) async {
    final currentState = state;
    if (currentState is SvgEditorLoaded) {
      final updatedElements = currentState.canvas.elements
          .where((e) => e.id != event.elementId)
          .toList();
      final updatedCanvas = currentState.canvas.copyWith(
        elements: updatedElements,
        updatedAt: DateTime.now(),
      );
      emit(SvgEditorLoaded(canvas: updatedCanvas, selectedElementId: null));
    }
  }

  Future<void> _onElementMoved(
    SvgElementMoved event,
    Emitter<SvgState> emit,
  ) async {
    final currentState = state;
    if (currentState is SvgEditorLoaded) {
      final updatedElements = currentState.canvas.elements.map((e) {
        if (e.id == event.elementId) {
          return e.copyWith(x: event.x, y: event.y);
        }
        return e;
      }).toList();
      final updatedCanvas = currentState.canvas.copyWith(
        elements: updatedElements,
        updatedAt: DateTime.now(),
      );
      emit(
        SvgEditorLoaded(
          canvas: updatedCanvas,
          selectedElementId: currentState.selectedElementId,
        ),
      );
    }
  }

  Future<void> _onElementSelected(
    SvgElementSelected event,
    Emitter<SvgState> emit,
  ) async {
    final currentState = state;
    if (currentState is SvgEditorLoaded) {
      emit(
        SvgEditorLoaded(
          canvas: currentState.canvas,
          selectedElementId: event.elementId,
        ),
      );
    }
  }

  Future<void> _onCanvasSaved(
    SvgCanvasSaved event,
    Emitter<SvgState> emit,
  ) async {
    final currentState = state;
    if (currentState is SvgEditorLoaded) {
      try {
        await _svgRepository.updateCanvas(currentState.canvas);
      } catch (e) {
        emit(SvgError(e.toString()));
      }
    }
  }

  Future<void> _onCanvasUpdated(
    SvgCanvasUpdated event,
    Emitter<SvgState> emit,
  ) async {
    final currentState = state;
    if (currentState is SvgEditorLoaded) {
      emit(
        SvgEditorLoaded(
          canvas: event.canvas,
          selectedElementId: currentState.selectedElementId,
        ),
      );
    }
  }
}
