import 'package:dio/dio.dart';
import '../core/config/app_config.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 添加日志拦截器（仅在调试模式下）
    if (AppConfig.debugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  /// 获取验证码图片
  Future<CaptchaResponse> getCaptchaImage() async {
    try {
      final response = await _dio.get('/captchaImage');
      final data = response.data;
      return CaptchaResponse(img: data['img'] ?? '', uuid: data['uuid'] ?? '');
    } catch (e) {
      throw Exception('获取验证码失败: $e');
    }
  }

  /// 用户登录
  Future<LoginResponse> login({
    required String username,
    required String password,
    required String code,
    required String uuid,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'username': username,
          'password': password,
          'code': code,
          'uuid': uuid,
        },
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }
}

class CaptchaResponse {
  final String img;
  final String uuid;

  CaptchaResponse({required this.img, required this.uuid});

  /// 获取完整的base64图片数据
  String get fullBase64Image => 'data:image/gif;base64,$img';
}

class LoginResponse {
  final String token;
  final Map<String, dynamic>? userInfo;

  LoginResponse({required this.token, this.userInfo});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userInfo: json['userInfo'],
    );
  }
}
