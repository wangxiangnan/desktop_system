import 'package:desktop_system/core/network/dio_client.dart';
import 'package:desktop_system/data/models/user_model.dart';
import 'package:desktop_system/domain/repositories/auth_repository.dart';

const _authBasePath = '';

/// Remote data source for authentication using Dio
class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource(this._dioClient);

  /// Get captcha image
  Future<CaptchaData> getCaptchaImage() async {
    final response = await _dioClient.get('$_authBasePath/captchaImage');
    final data = response.data;
    return CaptchaData(img: data['img'] ?? '', uuid: data['uuid'] ?? '');
  }

  /// Login with credentials
  Future<LoginResult> login({
    required String username,
    required String password,
    required String code,
    required String uuid,
  }) async {
    final response = await _dioClient.post(
      '$_authBasePath/login',
      data: {
        'username': username,
        'password': password,
        'code': code,
        'uuid': uuid,
      },
    );

    final data = response.data;
    final token = data['token'] as String? ?? '';

    return LoginResult(token: token);
  }

  /// Logout
  Future<void> logout() async {
    await _dioClient.post('$_authBasePath/logout');
  }

  /// Get user info (permissions, roles, user)
  Future<({UserModel? user, List<String> permissions, List<String> roles})> getInfo() async {
    final response = await _dioClient.get('$_authBasePath/getInfo');
    final data = response.data;

    final permissions = List<String>.from(data['permissions'] ?? []);
    final roles = List<String>.from(data['roles'] ?? []);
    final userJson = data['user'] as Map<String, dynamic>?;

    return (
      user: userJson != null ? UserModel.fromJson(userJson) : null,
      permissions: permissions,
      roles: roles,
    );
  }

  /// Refresh token
  Future<String> refreshToken() async {
    final response = await _dioClient.post('$_authBasePath/refresh-token');
    return response.data['token'] as String? ?? '';
  }
}
