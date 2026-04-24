import 'package:desktop_system/domain/entities/user_entity.dart';
import 'package:desktop_system/domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/storage_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageDataSource _storageDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required StorageDataSource storageDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _storageDataSource = storageDataSource;

  @override
  Future<CaptchaData> getCaptchaImage() async {
    return await _remoteDataSource.getCaptchaImage();
  }

  @override
  Future<LoginResult> login({
    required String username,
    required String password,
    required String code,
    required String uuid,
  }) async {
    final result = await _remoteDataSource.login(
      username: username,
      password: password,
      code: code,
      uuid: uuid,
    );

    await _storageDataSource.saveToken(result.token);

    final infoResult = await _remoteDataSource.getInfo();
    if (infoResult.user != null) {
      await _storageDataSource.saveUserInfo(
        userId: infoResult.user!.id,
        username: infoResult.user!.username,
        role: infoResult.user!.role.name,
        name: infoResult.user!.name,
        permissions: infoResult.permissions,
        roles: infoResult.roles,
      );
    }

    return LoginResult(token: result.token, user: infoResult.user);
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } finally {
      await _storageDataSource.clearUserData();
    }
  }

  @override
  Future<UserInfoResult> getInfo() async {
    final result = await _remoteDataSource.getInfo();

    if (result.user != null) {
      await _storageDataSource.saveUserInfo(
        userId: result.user!.id,
        username: result.user!.username,
        role: result.user!.role.name,
        name: result.user!.name,
        permissions: result.permissions,
        roles: result.roles,
      );
    }

    return result;
  }

  @override
  Future<User?> getCurrentUser() async {
    if (!_storageDataSource.isLoggedIn()) {
      return null;
    }

    final userInfo = _storageDataSource.getUserInfo();
    if (userInfo['userId'] == null) {
      return null;
    }

    return User(
      id: userInfo['userId']!,
      username: userInfo['username'] ?? '',
      name: userInfo['name'] as String? ?? userInfo['username'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == userInfo['role'],
        orElse: () => UserRole.user,
      ),
      permissions: List<String>.from(userInfo['permissions'] ?? []),
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return _storageDataSource.isLoggedIn();
  }

  @override
  Future<String?> getToken() async {
    return _storageDataSource.getToken();
  }
}
