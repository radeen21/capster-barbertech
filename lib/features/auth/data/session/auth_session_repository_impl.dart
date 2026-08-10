import 'package:capster_barbertech/features/auth/domain/session/auth_session_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionRepositoryImpl implements AuthSessionRepository {
  static const _keyUserId = "user_id";
  static const _keySessionToken = "session_token";
  static const _keyRefreshToken = "refresh_token";
  static const _keySessionExpiresAt = "session_expires_at";
  static const _keyRefreshExpiresAt = "refresh_expires_at";
  static const _keyRole = "role";
  static const _keyPoint = "user_point";
  

  String? _userId;
  String? _sessionToken;
  String? _refreshToken;
  DateTime? _sessionExpiresAt;
  DateTime? _refreshExpiresAt;
  String? _role;
  bool _activeServiceHasAddons = false;
  int _point = 0;
  String? _userName;

  // =====================
  // LOAD SESSION (APP START)
  // =====================
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString(_keyUserId);
    _sessionToken = prefs.getString(_keySessionToken);
    _refreshToken = prefs.getString(_keyRefreshToken);

    final sessionExp = prefs.getString(_keySessionExpiresAt);
    final refreshExp = prefs.getString(_keyRefreshExpiresAt);

    _sessionExpiresAt =
        sessionExp != null ? DateTime.tryParse(sessionExp) : null;
    _refreshExpiresAt =
        refreshExp != null ? DateTime.tryParse(refreshExp) : null;

    _role = prefs.getString(_keyRole);
    _point = prefs.getInt(_keyPoint) ?? 0;

    _userName = prefs.getString("session_name");

    print("🔄 SESSION LOADED");
    print("   userId = $_userId");
    print("   role   = $_role");
    print("   point  = $_point");
  }

  // =====================
  // GETTERS
  // =====================
  @override
  String? getUserId() => _userId;

  @override
  String? getSessionToken() => _sessionToken;

  @override
  String? getRefreshToken() => _refreshToken;

  @override
  String? getRole() => _role;

  @override
  int getPoint() => _point;

  // =====================
  // LOGIN STATE
  // =====================
  @override
  bool isLoggedIn() {
    if (_sessionToken == null || _sessionExpiresAt == null) return false;
    return _sessionExpiresAt!.isAfter(DateTime.now());
  }

  // =====================
  // SAVE SESSION (LOGIN)
  // =====================
  @override
  Future<void> saveSession({
    required String userId,
    required String sessionToken,
    required String refreshToken,
    required DateTime sessionExpiresAt,
    required DateTime refreshExpiresAt,
    String? role,
    required int point,
     String? userName,
  }) async {
     _userName = userName;

    final prefs = await SharedPreferences.getInstance();

    _userId = userId;
    _sessionToken = sessionToken;
    _refreshToken = refreshToken;
    _sessionExpiresAt = sessionExpiresAt;
    _refreshExpiresAt = refreshExpiresAt;
    _role = role;
    _point = point;

    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keySessionToken, sessionToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(
      _keySessionExpiresAt,
      sessionExpiresAt.toIso8601String(),
    );
    await prefs.setString(
      _keyRefreshExpiresAt,
      refreshExpiresAt.toIso8601String(),
    );

    if (role != null) {
      await prefs.setString(_keyRole, role);
    }

    await prefs.setInt(_keyPoint, point);

    print("✅ SESSION SAVED");
    print("🔐 TOKEN = $sessionToken");
    print("💰 POINT = $point");
  }

  // =====================
  // UPDATE POINT (AFTER REDEEM)
  // =====================
  @override
  Future<void> savePoint(int point) async {
    final prefs = await SharedPreferences.getInstance();
    _point = point;
    await prefs.setInt(_keyPoint, point);

    print("💰 POINT UPDATED = $point");
  }

  // =====================
  // CLEAR SESSION (LOGOUT)
  // =====================
  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    _userId = null;
    _sessionToken = null;
    _refreshToken = null;
    _sessionExpiresAt = null;
    _refreshExpiresAt = null;
    _role = null;
    _point = 0;

    await prefs.remove(_keyUserId);
    await prefs.remove(_keySessionToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keySessionExpiresAt);
    await prefs.remove(_keyRefreshExpiresAt);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyPoint);

    print("🧹 SESSION CLEARED");
  }

  // =====================
  // ADDONS FLAG
  // =====================
  @override
  void setActiveServiceHasAddons(bool value) {
    _activeServiceHasAddons = value;
  }

  @override
  bool getActiveServiceHasAddons() {
    return _activeServiceHasAddons;
  }
  
  @override
  String? getUserName() {
    String? getUserName() => _userName;
  }
}
