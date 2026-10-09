import 'package:dart_postgres_api/models/task.dart';
import 'package:postgres/postgres.dart';

class TaskRepository {
  final Connection db;
  TaskRepository(this.db);

  Future<List<Task>> getTasks() async {
    final result = await db.execute(
      Sql.named('''
        SELECT
          id,
          title,
          description,
          is_completed,
          created_at
        FROM tasks
        ORDER BY id
        '''),
    );
    return result.map((row) {
      return Task.fromMap(row.toColumnMap());
    }).toList();
  }
}
