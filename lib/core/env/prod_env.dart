import 'env_config.dart';

class ProdEnv implements EnvConfig {
  @override
  String get baseUrl => "https://barbertech.id/api/v1";
}
