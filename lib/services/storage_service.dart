import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserToken = 'user_token';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';

  bool get isLoggedIn => _prefs.getBool(keyIsLoggedIn) ?? false;

  String? get userToken => _prefs.getString(keyUserToken);

  String? get userId => _prefs.getString(keyUserId);

  String? get userName => _prefs.getString(keyUserName);

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(keyIsLoggedIn, value);
  }

  Future<void> setUserToken(String token) async {
    await _prefs.setString(keyUserToken, token);
  }

  Future<void> setUserId(String id) async {
    await _prefs.setString(keyUserId, id);
  }

  Future<void> setUserName(String name) async {
    await _prefs.setString(keyUserName, name);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  Future<void> logout() async {
    await _prefs.remove(keyIsLoggedIn);
    await _prefs.remove(keyUserToken);
    await _prefs.remove(keyUserId);
    await _prefs.remove(keyUserName);
  }
}
