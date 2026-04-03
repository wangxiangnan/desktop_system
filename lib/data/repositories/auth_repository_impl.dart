import '../models/user_model.dart';
import 'auth_repository.dart';
import '../../services/storage_service.dart';
import '../../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final StorageService _storageService;
  final AuthService _authService;

  AuthRepositoryImpl(this._storageService, this._authService);

  @override
  Future<UserModel> login(
    String username,
    String password,
    String code,
    String uuid,
  ) async {
    try {
      final response = await _authService.login(
        username: username,
        password: password,
        code: code,
        uuid: uuid,
      );

      // 保存token
      await _storageService.setLoggedIn(true);
      await _storageService.setUserToken(response.token);

      // 解析用户信息
      final userInfo = response.userInfo ?? {};
      final user = UserModel(
        id: userInfo['id']?.toString() ?? '1',
        username: userInfo['username'] ?? username,
        name: userInfo['name'] ?? username,
        role: _parseUserRole(userInfo['role']),
        permissions: _parsePermissions(userInfo['permissions']),
      );

      await _storageService.setUserId(user.id);
      await _storageService.setUserName(user.name);

      return user;
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  UserRole _parseUserRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      case 'viewer':
        return UserRole.viewer;
      default:
        return UserRole.user;
    }
  }

  List<String> _parsePermissions(dynamic permissions) {
    if (permissions is List) {
      return permissions.map((e) => e.toString()).toList();
    }
    return ['view_ticket'];
  }

  @override
  Future<void> logout() async {
    await _storageService.logout();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (!await isLoggedIn()) return null;

    final userId = _storageService.userId;
    final userName = _storageService.userName;

    if (userId == null || userName == null) return null;

    return UserModel(
      id: userId,
      username: userName.toLowerCase(),
      name: userName,
      role: UserRole.user,
      permissions: const ['view_ticket'],
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return _storageService.isLoggedIn;
  }

  @override
  Future<Map<String, String>> getCaptchaImage() async {
    try {
      final response = await _authService.getCaptchaImage();
      return {'img': response.fullBase64Image, 'uuid': response.uuid};
    } catch (e) {
      throw Exception('获取验证码失败: $e');
    }
  }
}
