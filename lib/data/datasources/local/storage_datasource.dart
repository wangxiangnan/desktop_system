import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for storing auth tokens
class StorageDataSource {
  static const String _tokenKey = 'auth_token';

  final SharedPreferences _prefs;

  StorageDataSource(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  bool isLoggedIn() {
    return _prefs.getString(_tokenKey) != null;
  }

  Future<void> clearUserData() async {
    await _prefs.remove(_tokenKey);
  }
}
