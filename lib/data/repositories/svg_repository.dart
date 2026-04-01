import '../models/svg_model.dart';

abstract class SvgRepository {
  Future<List<SvgCanvasModel>> getCanvases();
  Future<SvgCanvasModel> getCanvasById(String id);
  Future<SvgCanvasModel> createCanvas(SvgCanvasModel canvas);
  Future<SvgCanvasModel> updateCanvas(SvgCanvasModel canvas);
  Future<void> deleteCanvas(String id);
}
