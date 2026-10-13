import 'package:dart_postgres_api/models/task.dart';
import 'package:dart_postgres_api/repositories/task_repository.dart';

class TaskService {
  final TaskRepository repository;
  TaskService(this.repository);

  Future<List<Task>> getTasks() async {
    return repository.getTasks();
  }

  Future<Task> createTask({
    required int userId,
    required String title,
    String? description,
  }) async {
    final nTitle = title.trim();

    if (nTitle.isEmpty) {
      throw ArgumentError('Task title cannot be empty');
    }
    if (nTitle.length > 255) {
      throw ArgumentError('task can\'t exceed 255 charecters ');
    }

    final nDescription = description?.trim();

    return repository.createTask(
      userId: userId,
      title: nTitle,
      description: nDescription == null || nDescription.isEmpty
          ? null
          : nDescription,
    );
  }

  Future<Task?> getTaskById({required int id, required int userId}) async {
    if (id <= 0 && userId <= 0) {
      throw ArgumentError('id and user_id must be greater than zero');
    }
    return repository.getTaskById(id: id, userId: userId);
  }

  Future<Task> updateTask({
    required int id,
    required String title,
    String? description,
    bool? isCompleted,
  }) async {
    if (id <= 0) {
      throw FormatException('id can\'t be zero || nagative ..');
    }

    final nTitle = title.trim();

    if (nTitle.isEmpty) {
      throw ArgumentError('Task title cannot be empty');
    }
    if (nTitle.length > 255) {
      throw ArgumentError('task can\'t exceed 255 charecters ');
    }

    final nDescription = description?.trim();

    return repository.updateTask(
      id: id,
      title: title,
      description: nDescription == null || nDescription.isEmpty
          ? null
          : nDescription,
      isCompleted: isCompleted,
    );
  }
}
