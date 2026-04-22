import '../../../core/network/dio_client.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

/// Remote data source for authentication using Dio
class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource(this._dioClient);

  /// Get captcha image
  Future<CaptchaData> getCaptchaImage() async {
    final response = await _dioClient.get('/captchaImage');
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
      '/login',
      data: {
        'username': username,
        'password': password,
        'code': code,
        'uuid': uuid,
      },
    );

    final data = response.data;
    final token = data['token'] as String? ?? '';

    return LoginResult(token: token, user: null);
  }

  /// Logout
  Future<void> logout() async {
    await _dioClient.post('/logout');
  }

  /// Get user info (permissions, roles, user)
  Future<UserInfoResult> getInfo() async {
    final response = await _dioClient.get('/getInfo');
    final data = response.data;

    final permissions = List<String>.from(data['permissions'] ?? []);
    final roles = List<String>.from(data['roles'] ?? []);

    User? user;
    if (data['user'] != null) {
      user = User(
        id: data['user']['id'] as String? ?? '',
        username: data['user']['username'] as String? ?? '',
        name: data['user']['name'] as String? ?? '',
        role: UserRole.values.firstWhere(
          (e) => e.name == data['user']['role'],
          orElse: () => UserRole.user,
        ),
        permissions: permissions,
      );
    }

    return UserInfoResult(permissions: permissions, roles: roles, user: user);
  }

  /// Refresh token
  Future<String> refreshToken() async {
    final response = await _dioClient.post('/refresh-token');
    return response.data['token'] as String? ?? '';
  }
}
