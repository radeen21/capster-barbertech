import 'app_env.dart';

class EnvConfig {
  static String get baseUrl {
    switch (AppEnv.current) {
      case AppEnvironment.mock:
        return "https://6a93016d-1946-4c80-bc1c-b137f8404a4c.mock.pstmn.io";

      case AppEnvironment.dev:
        return "https://hubcoban.web.id/api/v1";

      case AppEnvironment.prod:
        return "https://barbertech.id/api/v1";
    }
  }
}
