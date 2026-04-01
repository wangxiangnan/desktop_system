import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(
    String username,
    String password,
    String code,
    String uuid,
  );
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<Map<String, String>> getCaptchaImage();
}
