import '../../core/network/dio_client.dart';
import '../data/models/svg_model.dart';

class SvgService {
  final DioClient _dioClient;

  SvgService(this._dioClient);

  /// 获取画布列表
  Future<List<SvgCanvasModel>> getCanvases() async {
    try {
      final response = await _dioClient.get('/canvases');
      final List<dynamic> canvasesJson = response.data['canvases'] ?? [];
      return canvasesJson.map((json) => SvgCanvasModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('获取画布列表失败: $e');
    }
  }

  /// 根据ID获取画布
  Future<SvgCanvasModel> getCanvasById(String id) async {
    try {
      final response = await _dioClient.get('/canvases/$id');
      return SvgCanvasModel.fromJson(response.data);
    } catch (e) {
      throw Exception('获取画布详情失败: $e');
    }
  }

  /// 创建画布
  Future<SvgCanvasModel> createCanvas(SvgCanvasModel canvas) async {
    try {
      final response = await _dioClient.post(
        '/canvases',
        data: canvas.toJson(),
      );
      return SvgCanvasModel.fromJson(response.data);
    } catch (e) {
      throw Exception('创建画布失败: $e');
    }
  }

  /// 更新画布
  Future<SvgCanvasModel> updateCanvas(SvgCanvasModel canvas) async {
    try {
      final response = await _dioClient.put(
        '/canvases/${canvas.id}',
        data: canvas.toJson(),
      );
      return SvgCanvasModel.fromJson(response.data);
    } catch (e) {
      throw Exception('更新画布失败: $e');
    }
  }

  /// 删除画布
  Future<void> deleteCanvas(String id) async {
    try {
      await _dioClient.delete('/canvases/$id');
    } catch (e) {
      throw Exception('删除画布失败: $e');
    }
  }
}
