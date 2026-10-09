import 'package:dotenv/dotenv.dart' as dotenv;

class Env {
  static late final dotenv.DotEnv env;
  Env() {
    env = dotenv.DotEnv(includePlatformEnvironment: true)..load();
  }

  String get dbHost => env['DB_HOST']!;
  int get dbPort => int.parse(env['DB_PORT']!);
  String get dbName => env['DB_NAME']!;
  String get dbUser => env['DB_USER']!;
  String get dbPassword => env['DB_PASSWORD']!;
}
