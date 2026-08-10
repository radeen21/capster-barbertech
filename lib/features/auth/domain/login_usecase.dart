import 'package:capster_barbertech/features/auth/domain/auth_repository.dart';
import 'package:capster_barbertech/features/auth/domain/session/auth_session_repository.dart';
import 'package:capster_barbertech/features/auth/domain/user_entity.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  final AuthSessionRepository sessionRepository;

  LoginUseCase({
    required this.authRepository,
    required this.sessionRepository,
  });

  Future<UserEntity> call(String email, String password) async {
    final user = await authRepository.login(email, password);

    await sessionRepository.saveSession(
      userId: user.id,
      sessionToken: user.sessionToken,
      refreshToken: user.refreshToken,
      sessionExpiresAt: user.sessionExpiresAt,
      refreshExpiresAt: user.refreshExpiresAt,
      role: user.role,
      point: user.point,
      userName: user.fullName,
    );

    return user;
  }
}
