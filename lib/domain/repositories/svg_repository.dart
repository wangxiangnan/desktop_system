import '../entities/svg_entity.dart';

/// Abstract repository interface for SVG canvases
abstract class SvgRepository {
  /// Get all canvases
  Future<List<SvgCanvas>> getCanvases();

  /// Get canvas by ID
  Future<SvgCanvas> getCanvasById(String id);

  /// Create a new canvas
  Future<SvgCanvas> createCanvas(SvgCanvas canvas);

  /// Update an existing canvas
  Future<SvgCanvas> updateCanvas(SvgCanvas canvas);

  /// Delete a canvas
  Future<void> deleteCanvas(String id);
}
