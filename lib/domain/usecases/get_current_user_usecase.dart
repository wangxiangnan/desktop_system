import 'package:desktop_system/core/result/result.dart';
import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<Result<User?>> call() async {
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
}