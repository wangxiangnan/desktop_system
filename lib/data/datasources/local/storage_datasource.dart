import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for storing auth tokens and user data
class StorageDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _userRoleKey = 'user_role';
  static const String _userNameKey = 'user_name';
  static const String _permissionsKey = 'permissions';
  static const String _rolesKey = 'roles';

  final SharedPreferences _prefs;

  StorageDataSource(this._prefs);

  /// Save auth token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Get stored token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Remove token
  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  /// Check if logged in
  bool isLoggedIn() {
    return _prefs.getString(_tokenKey) != null;
  }

  /// Save user info
  Future<void> saveUserInfo({
    required String userId,
    required String username,
    required String role,
    String? name,
    List<String>? permissions,
    List<String>? roles,
  }) async {
    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_usernameKey, username);
    await _prefs.setString(_userRoleKey, role);
    if (name != null) {
      await _prefs.setString(_userNameKey, name);
    }
    if (permissions != null) {
      await _prefs.setStringList(_permissionsKey, permissions);
    }
    if (roles != null) {
      await _prefs.setStringList(_rolesKey, roles);
    }
  }

  /// Get user info
  Map<String, dynamic> getUserInfo() {
    return {
      'userId': _prefs.getString(_userIdKey),
      'username': _prefs.getString(_usernameKey),
      'role': _prefs.getString(_userRoleKey),
      'name': _prefs.getString(_userNameKey),
      'permissions': _prefs.getStringList(_permissionsKey),
      'roles': _prefs.getStringList(_rolesKey),
    };
  }

  /// Clear all user data
  Future<void> clearUserData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_usernameKey);
    await _prefs.remove(_userRoleKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_permissionsKey);
    await _prefs.remove(_rolesKey);
  }
}
