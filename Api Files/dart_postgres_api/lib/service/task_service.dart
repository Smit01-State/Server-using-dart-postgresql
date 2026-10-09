import 'package:dart_postgres_api/models/task.dart';
import 'package:dart_postgres_api/repositories/task_repository.dart';

class TaskService {
  final TaskRepository repository;
  TaskService(this.repository);

  Future<List<Task>> getTasks() async {
    return repository.getTasks();
  }
}
