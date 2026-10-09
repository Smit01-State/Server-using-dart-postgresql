import 'package:dart_postgres_api/Env/env.dart';
import 'package:postgres/postgres.dart';

class Database {
  late final Connection connection;

  Future<void> connect() async {
    final env = Env();
    connection = await Connection.open(
      Endpoint(
        host: env.dbHost,
        database: env.dbName,
        port: env.dbPort,
        username: env.dbUser,
        password: env.dbPassword,
      ),
      settings: ConnectionSettings(sslMode: .disable),
    );
    if (connection.isOpen) {
      print('Database has connected');
      final result = await connection.execute(Sql.named('SELECT version()'));
      print(result.first.first);
    }
  }

  Future<void> close() async {
    await connection.close();
  }
}
