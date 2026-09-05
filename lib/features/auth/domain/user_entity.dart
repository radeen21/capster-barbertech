import 'dart:ffi';

class UserEntity {
  final String id;
  final String role;
  final String fullName;

  final String sessionToken;
  final String refreshToken;
  final DateTime sessionExpiresAt;
  final DateTime refreshExpiresAt;

  final int point;

   final int target;
  final int achievement;

  UserEntity({
    required this.id,
    required this.role,
    required this.fullName,
    required this.sessionToken,
    required this.refreshToken,
    required this.sessionExpiresAt,
    required this.refreshExpiresAt,
    required this.point,
    required this.target,
    required this.achievement,
  });
}
