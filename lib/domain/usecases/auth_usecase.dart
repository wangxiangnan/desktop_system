import 'package:desktop_system/core/result/result.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class CaptchaData {
  final String imageBase64;
  final String uuid;

  const CaptchaData({
    required this.imageBase64,
    required this.uuid,
  });

  String get fullImageData => 'data:image/gif;base64,$imageBase64';
}

class AuthUseCase {
  final AuthRepository _repository;

  const AuthUseCase(this._repository);

  Future<Result<User>> login(LoginParams params) async {
    try {
      await _repository.login(
        username: params.username,
        password: params.password,
        code: params.code,
        uuid: params.uuid,
      );
      final user = await _repository.getInfo();

      if (user != null) {
        return Success(user);
      }
      return const Failure(
        AppError(message: 'Login failed: No user returned'),
      );
    } catch (e) {
      return Failure(
        e is AppError
            ? e
            : AppError.auth(message: 'Login failed: ${e.toString()}'),
      );
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _repository.logout();
      return const Success(null);
    } catch (e) {
      return Failure(
        e is AppError
            ? e
            : AppError.unknown(message: 'Logout failed: ${e.toString()}'),
      );
    }
  }

  Future<Result<User?>> getCurrentUser() async {
    try {
      final user = await _repository.getInfo();
      return Success(user);
    } catch (e) {
      return Failure(
        e is AppError
            ? e
            : AppError.unknown(message: 'Failed to get user: ${e.toString()}'),
      );
    }
  }

  Future<bool> isLoggedIn() async {
    return await _repository.isLoggedIn();
  }

  Future<Result<CaptchaData>> getCaptcha() async {
    try {
      final result = await _repository.getCaptchaImage();
      return Success(
        CaptchaData(
          imageBase64: result.img,
          uuid: result.uuid,
        ),
      );
    } catch (e) {
      return Failure(
        e is AppError
            ? e
            : AppError.unknown(message: 'Failed to get captcha: ${e.toString()}'),
      );
    }
  }
}

class LoginParams {
  final String username;
  final String password;
  final String code;
  final String uuid;

  const LoginParams({
    required this.username,
    required this.password,
    required this.code,
    required this.uuid,
  });
}
