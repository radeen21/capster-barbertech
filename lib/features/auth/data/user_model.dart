import 'package:capster_barbertech/features/auth/domain/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.role,
    required super.fullName,
    required super.sessionToken,
    required super.refreshToken,
    required super.sessionExpiresAt,
    required super.refreshExpiresAt,
    required super.point,
    required super.target,
    required super.achievement,
  });

  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    final data = json["data"];
    if (data == null) {
      throw Exception("Login response invalid: data is null");
    }

    final user = data["user"];
    if (user == null) {
      throw Exception("Login response invalid: user is null");
    }
    final capster = data["capster"];

    return UserModel(
      id: user["id"],
      role: user["role"],
      fullName: user["full_name"],

      sessionToken: data["session_token"],
      refreshToken: data["refresh_token"],
      sessionExpiresAt: DateTime.parse(data["session_expires_at"]),
      refreshExpiresAt: DateTime.parse(data["refresh_expires_at"]),

      point: user["point"] ?? 0,

      target: capster?["target"] ?? 0,
      achievement: capster?["achievement"] ?? 0,
    );
  }
}
