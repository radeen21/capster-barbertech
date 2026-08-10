import 'package:capster_barbertech/core/session/auth_session.dart';

class AuthSessionImpl implements AuthSession {
  String? _userId;
  String? _sessionToken;
  String? _refreshToken;
  DateTime? _sessionExpiresAt;
  DateTime? _refreshExpiresAt;
  String? _role;

  @override
  String? get userId => _userId;

  @override
  String? get sessionToken => _sessionToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  DateTime? get sessionExpiresAt => _sessionExpiresAt;

  @override
  DateTime? get refreshExpiresAt => _refreshExpiresAt;

  @override
  String? get role => _role;

  @override
  bool get isLoggedIn =>
      _userId != null &&
      _sessionToken != null &&
      _sessionExpiresAt != null &&
      _sessionExpiresAt!.isAfter(DateTime.now());

  @override
  void saveSession({
    required String userId,
    required String sessionToken,
    required String refreshToken,
    required DateTime sessionExpiresAt,
    required DateTime refreshExpiresAt,
    String? role,
  }) {
    _userId = userId;
    _sessionToken = sessionToken;
    _refreshToken = refreshToken;
    _sessionExpiresAt = sessionExpiresAt;
    _refreshExpiresAt = refreshExpiresAt;
    _role = role;
  }

  @override
  void clear() {
    _userId = null;
    _sessionToken = null;
    _refreshToken = null;
    _sessionExpiresAt = null;
    _refreshExpiresAt = null;
    _role = null;
  }
}
