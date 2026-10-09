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
}
