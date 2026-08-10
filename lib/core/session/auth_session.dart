abstract class AuthSession {
  String? get userId;
  String? get sessionToken;
  String? get refreshToken;
  DateTime? get sessionExpiresAt;
  DateTime? get refreshExpiresAt;
  String? get role;

  bool get isLoggedIn;

  void saveSession({
    required String userId,
    required String sessionToken,
    required String refreshToken,
    required DateTime sessionExpiresAt,
    required DateTime refreshExpiresAt,
    String? role,
  });

  void clear();
}
