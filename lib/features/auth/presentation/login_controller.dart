import 'package:capster_barbertech/features/auth/domain/login_usecase.dart';

class LoginController {
  final LoginUseCase loginUseCase;
  LoginController(this.loginUseCase);

  Future<bool> login(String email, String password) async {
    try {
      await loginUseCase(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
