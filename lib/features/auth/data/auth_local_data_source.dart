import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveLogin(Map<String, dynamic> json);
  Future<void> saveRefresh(Map<String, dynamic> json);

  Future<bool> isLoggedIn();
  Future<String?> getRole();
  Future<String?> getRefreshToken();

  Future<void> logout();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> saveLogin(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("session_token", json["session_token"]);
    await prefs.setString("refresh_token", json["refresh_token"]);
    await prefs.setString("role", json["user"]["role"]);
  }

  @override
  Future<void> saveRefresh(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("session_token", json["session_token"]);
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("session_token") != null;
  }

  @override
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  @override
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh_token");
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
