import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static const _keyUserToken = 'token';
  static const _keyUserName = 'userName';
  static const _keyUserEmail = 'userEmail';
  static const _keyUserAvatar = 'avatar';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setToken(String token) async =>
      await _preferences?.setString(_keyUserToken, token);
  static Future setName(String userName) async =>
      await _preferences?.setString(_keyUserName, userName);
  static Future setEmail(String userEmail) async =>
      await _preferences?.setString(_keyUserEmail, userEmail);
  static Future setAvatar(String userAvatar) async =>
      await _preferences?.setString(_keyUserAvatar, userAvatar);

  static String? getToken() => _preferences!.getString(_keyUserToken);
  static String? getName() => _preferences!.getString(_keyUserName);
  static String? getEmail() => _preferences!.getString(_keyUserEmail);
  static String? getAvatar() => _preferences!.getString(_keyUserAvatar);
}
