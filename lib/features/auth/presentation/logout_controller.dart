import 'package:capster_barbertech/features/auth/domain/logout_usecase.dart';

class LogoutController {
  final LogoutUseCase logoutUseCase;

  LogoutController(this.logoutUseCase);

  Future<void> logout() async {
    await logoutUseCase();
  }
}
