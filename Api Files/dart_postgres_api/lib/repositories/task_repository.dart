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

  Future<Task?> getTaskById({required int id, required int userId}) async {
    final result = await db.execute(
      Sql.named('''
        SELECT id , title, description, is_completed, created_at FROM tasks WHERE id = @id AND user_id = @userId
      '''),
      parameters: {'id': id, 'userId': userId},
    );

    if (result.isEmpty) {
      return null;
    }
    return Task.fromMap(result.first.toColumnMap());
  }

  Future<Task> createTask({
    required int userId,
    required String title,
    String? description,
  }) async {
    final result = await db.execute(
      Sql.named(''' 
      INSERT INTO tasks (user_id,title,description)
      VALUES (@user_id, @title , @description)
      RETURNING *
      '''),
      parameters: {
        'user_id': userId,
        'title': title,
        'description': description,
      },
    );
    return Task.fromMap(result.first.toColumnMap());
  }

  Future<Task> updateTask({
    required int id,
    required String title,
    String? description,
    bool? isCompleted,
  }) async {
    final result = await db.execute(
      Sql.named('''
      UPDATE tasks
      SET 
      title = @title,
      description = @description,
      is_completed = @isCompleted
      WHERE id = @id
      RETURNING 
      id , title , description , is_completed , created_at
      '''),
      parameters: {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
      },
    );

    return Task.fromMap(result.first.toColumnMap());
  }
}
