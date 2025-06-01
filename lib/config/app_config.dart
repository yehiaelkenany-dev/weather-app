import 'package:envied/envied.dart';

part 'app_config.g.dart'; // This will be generated

@Envied(path: '.env')
abstract class AppConfig {
  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _AppConfig.apiKey;
}
