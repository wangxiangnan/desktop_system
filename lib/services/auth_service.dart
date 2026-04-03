import '../../core/network/dio_client.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  /// 获取验证码图片
  Future<CaptchaResponse> getCaptchaImage() async {
    try {
      final response = await _dioClient.get('/captchaImage');
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
      final response = await _dioClient.post(
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

  /// 用户登出
  Future<void> logout() async {
    try {
      await _dioClient.post('/logout');
    } catch (e) {
      throw Exception('登出失败: $e');
    }
  }

  /// 刷新token
  Future<String> refreshToken() async {
    try {
      final response = await _dioClient.post('/refresh-token');
      return response.data['token'] ?? '';
    } catch (e) {
      throw Exception('刷新token失败: $e');
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
