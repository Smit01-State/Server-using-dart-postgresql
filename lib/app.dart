import 'package:dart_postgres_api/database/database.dart';
import 'package:dart_postgres_api/router/router.dart';
import 'package:shelf/shelf.dart';

Handler createApp(Database database) { 
  final router = createRouter(database);

  return const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
}
