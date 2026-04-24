import 'package:desktop_system/core/result/result.dart';
import '../repositories/auth_repository.dart';

class CaptchaData {
  final String imageBase64;
  final String uuid;

  const CaptchaData({
    required this.imageBase64,
    required this.uuid,
  });

  String get fullImageData => 'data:image/gif;base64,$imageBase64';
}

class GetCaptchaUseCase {
  final AuthRepository _repository;

  const GetCaptchaUseCase(this._repository);

  Future<Result<CaptchaData>> call() async {
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