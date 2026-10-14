import 'package:dart_postgres_api/controller/task_controller.dart';
import 'package:dart_postgres_api/database/database.dart';
import 'package:dart_postgres_api/repositories/task_repository.dart';
import 'package:dart_postgres_api/service/task_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router createRouter(Database database) {
  final router = Router();
  final taskRepository = TaskRepository(database.connection);
  final taskService = TaskService(taskRepository);
  final taskController = TaskController(taskService);

  router.get('/api/health', (Request request) {
    return Response.ok(
      '{"status":"ok"}',
      headers: {'content-type': 'application/json'},
    );
  });

  router.get('/api/tasks', taskController.getTasks);
  router.post('/api/tasks', taskController.createTask);
  router.get('/api/tasks/:id', taskController.getTaskById);
  router.put('/api/tasks/:id', taskController.updateTask);
  router.delete('/api/tasks/:id', taskController.deleteTask);

  return router;
}
