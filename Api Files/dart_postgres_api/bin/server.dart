import 'package:dart_postgres_api/app.dart';
import 'package:dart_postgres_api/database/database.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final database = Database();
  await database.connect();

  final handler = createApp(database);

  final server = await shelf_io.serve(handler, 'localhost', 8050);

  print('server Running on http://${server.address.host}:${server.port}');
}

// Response _router(Request request) {
//   return Response.ok(
//     '{"status":"ok"}',
//     headers: {'content-type': 'application/json'},
//   );
// }
