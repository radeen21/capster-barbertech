import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionLocalDataSource {
  static const _keyUserId = "user_id";
  static const _keySessionToken = "session_token";
  static const _keyRefreshToken = "refresh_token";
  static const _keyRole = "role";
  static const _keyIsLoggedIn = "is_logged_in";

  /// =====================
  /// SAVE SESSION
  /// =====================
  Future<void> saveSession({
    required String userId,
    required String sessionToken,
    required String refreshToken,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keySessionToken, sessionToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyRole, role);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  /// =====================
  /// GETTERS
  /// =====================
  String? getUserId() {
    return SharedPreferences.getInstance()
        .then((prefs) => prefs.getString(_keyUserId))
        as String?;
  }

  String? getSessionToken() {
    return SharedPreferences.getInstance()
        .then((prefs) => prefs.getString(_keySessionToken))
        as String?;
  }

  String? getRefreshToken() {
    return SharedPreferences.getInstance()
        .then((prefs) => prefs.getString(_keyRefreshToken))
        as String?;
  }

  String? getRole() {
    return SharedPreferences.getInstance()
        .then((prefs) => prefs.getString(_keyRole))
        as String?;
  }

  /// =====================
  /// LOGIN STATUS
  /// =====================
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// =====================
  /// CLEAR SESSION
  /// =====================
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
