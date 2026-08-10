enum AppEnvironment { mock, dev, prod }

class AppEnv {
  static AppEnvironment current = AppEnvironment.prod;
}
