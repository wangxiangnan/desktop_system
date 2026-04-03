import '../core/network/dio_client.dart';
import 'auth_service.dart';

/// @deprecated 请使用 AuthService 替代
class ApiService {
  final AuthService _authService;

  ApiService() : _authService = AuthService(DioClient());

  /// 获取验证码图片
  /// @deprecated 请使用 AuthService.getCaptchaImage()
  Future<CaptchaResponse> getCaptchaImage() async {
    return _authService.getCaptchaImage();
  }

  /// 用户登录
  /// @deprecated 请使用 AuthService.login()
  Future<LoginResponse> login({
    required String username,
    required String password,
    required String code,
    required String uuid,
  }) async {
    return _authService.login(
      username: username,
      password: password,
      code: code,
      uuid: uuid,
    );
  }
}
