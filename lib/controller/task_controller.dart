import 'dart:convert';
import 'package:dart_postgres_api/service/task_service.dart';
import 'package:shelf/shelf.dart';

class TaskController {
  final TaskService service;
  TaskController(this.service);

  Future<Response> getTasks(Request request) async {
    final tasks = await service.getTasks();

    final data = tasks.map((task) {
      return task.toMap();
    }).toList();

    return Response.ok(
      jsonEncode(data),
      headers: {'content-type': 'application/json'},
    );
  }

  Future<Response> createTask(Request request) async {
    try {
      final body = await request.readAsString();
      final dynamic decode = jsonDecode(body);

      if (decode is! Map<String, dynamic>) {
        return _errorResponse(400, 'Request body must be a JSON object');
      }
      final userId = decode['user_id'];
      final title = decode['title'];
      final description = decode['description'];

      if (title is! String) {
        return _errorResponse(400, 'title is required and  must be String');
      }
      if (description is! String) {
        return _errorResponse(
          400,
          'describtion is required and  must be String',
        );
      }

      final task = await service.createTask(
        userId: userId,
        title: title,
        description: description as String?,
      );
      return Response(
        201,
        body: jsonEncode(task.toMap()),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return _errorResponse(400, 'invalid JSON');
    } on ArgumentError catch (error) {
      return _errorResponse(400, error.message.toString());
    }
  }

  Future<Response> getTaskById(Request request) async {
    try {
      final body = await request.readAsString();
      final decode = jsonDecode(body);

      if (decode is! Map<String, dynamic>) {
        return _errorResponse(400, 'Request body must be a JSON object');
      }
      final id = decode['id'];
      final userId = decode['user_id'];

      if (userId is! int && id is! int) {
        return _errorResponse(400, 'user_id and id must be integer value ');
      }
      final task = await service.getTaskById(id: id, userId: userId);
      return Response(
        201,
        body: jsonEncode(task!.toMap()),
        headers: {
          'content-type': 'application/json',
          'location': '/api/tasks/${task.id}',
        },
      );
    } on FormatException {
      return _errorResponse(400, 'invalid JSON');
    } on ArgumentError catch (error) {
      return _errorResponse(400, error.message.toString());
    }
  }

  Future<Response> updateTask(Request request) async {
    try {
      final body = await request.readAsString();
      final dynamic decode = jsonDecode(body);

      if (decode is! Map<String, dynamic>) {
        return _errorResponse(400, 'Request body must be a JSON object');
      }
      print(decode['title']);
      final id = decode['id'];
      final title = decode['title'];
      final description = decode['description'];
      final isCompleted = decode['is_completed'];

      print('title is ${title.runtimeType}');

      if (title is! String) {
        return _errorResponse(400, 'title is required and  must be String');
      }
      if (description is! String) {
        return _errorResponse(
          400,
          'describtion is required and  must be String',
        );
      }
      final task = await service.updateTask(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
      );

      return Response(
        201,
        body: jsonEncode(task.toMap()),
        headers: {'content-type': 'application/json'},
      );
    } on FormatException {
      return _errorResponse(400, 'invalid JSON');
    } on ArgumentError catch (error) {
      return _errorResponse(400, error.message.toString());
    }
  }

  Future<Response> deleteTask(Request request) async {
    try {
      final body = await request.readAsString();
      final dynamic decode = jsonDecode(body);

      if (decode is! Map<String, dynamic>) {
        return _errorResponse(400, 'Request body must be a JSON object');
      }
      final id = decode['id'];
      final isDeleted = await service.deleteTask(id);

      if (!isDeleted) {
        return _errorResponse(404, 'task not found');
      }

      return Response(204);
    } on ArgumentError catch (error) {
      return _errorResponse(400, error.message.toString());
    }
  }

  Response _errorResponse(int statusCode, String message) {
    return Response(
      statusCode,
      body: jsonEncode({'error': message}),
      headers: {'content-type': 'application/json'},
    );
  }
}
