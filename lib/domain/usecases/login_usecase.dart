import 'package:desktop_system/core/result/result.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

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

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<Result<User>> call(LoginParams params) async {
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
}