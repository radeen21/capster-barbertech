import 'env_config.dart';

class MockEnv implements EnvConfig {
  @override
  String get baseUrl => "http://localhost:3000";
}
