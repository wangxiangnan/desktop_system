import '../../core/result/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Result<void>> call() async {
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
}