import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'smart ai') // the .env variable.
  static const apiKey = _Env.apiKey;
}