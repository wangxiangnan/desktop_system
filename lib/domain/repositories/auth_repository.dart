import '../entities/user_entity.dart';

/// Captcha response data
class CaptchaData {
  final String img;
  final String uuid;

  CaptchaData({required this.img, required this.uuid});

  /// Get full base64 image data
  String get fullBase64Image => 'data:image/gif;base64,$img';
}

/// Login result data
class LoginResult {
  final String token;
  final User? user;

  LoginResult({required this.token, this.user});
}

/// User info result data (from getInfo API)
class UserInfoResult {
  final List<String> permissions;
  final List<String> roles;
  final User? user;

  UserInfoResult({
    required this.permissions,
    required this.roles,
    this.user,
  });
}

/// Abstract repository interface for authentication
abstract class AuthRepository {
  /// Get captcha image
  Future<CaptchaData> getCaptchaImage();

  /// Login with credentials
  Future<LoginResult> login({
    required String username,
    required String password,
    required String code,
    required String uuid,
  });

  /// Logout
  Future<void> logout();

  /// Get user info (permissions, roles, user)
  Future<UserInfoResult> getInfo();

  /// Get current user
  Future<User?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get stored token
  Future<String?> getToken();
}
