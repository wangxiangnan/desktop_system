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

    return LoginResult(token: result.token);
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
  Future<User?> getInfo() async {
    return await _remoteDataSource.getInfo();
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
