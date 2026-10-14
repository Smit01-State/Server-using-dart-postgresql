# Dart PostgreSQL API

This project is a simple REST API built with Dart using the `shelf` HTTP server and `shelf_router` for routing. It connects to a PostgreSQL database and exposes task-related endpoints.

## Project Structure

```text
dart_postgres_api/
├── bin/
│   └── server.dart               # app entry point
├── lib/
│   ├── app.dart                  # builds Shelf app
│   ├── Env/
│   │   └── env.dart              # environment variables
│   ├── controller/
│   │   └── task_controller.dart  # handles HTTP requests
│   ├── database/
│   │   └── database.dart         # PostgreSQL connection setup
│   ├── models/
│   │   └── task.dart             # task model
│   ├── repositories/
│   │   └── task_repository.dart  # SQL queries for tasks
│   ├── router/
│   │   └── router.dart           # route definitions
│   └── service/
│       └── task_service.dart     # business logic validation
├── test/                         # test folder
├── analysis_options.yaml
├── CHANGELOG.md
├── pubspec.yaml
├── README.md
└── .gitignore
```

## Project Overview

The application follows a clean layered architecture:

- `bin/server.dart` starts the server
- `lib/app.dart` creates the HTTP app pipeline
- `lib/router/router.dart` registers routes
- `lib/controller/task_controller.dart` handles HTTP requests
- `lib/service/task_service.dart` contains business logic
- `lib/repositories/task_repository.dart` talks to PostgreSQL
- `lib/database/database.dart` manages the database connection
- `lib/models/task.dart` defines the task model
- `lib/Env/env.dart` loads environment variables from the runtime environment

## Project Flow

### 1. Server startup
When the application starts, `bin/server.dart` runs:

1. Creates a `Database` object
2. Calls `database.connect()`
3. Builds the app using `createApp(database)`
4. Starts the HTTP server on `localhost:8050`

This is the entry point of the project.

### 2. App creation
The `createApp()` function in `lib/app.dart` does this:

1. Builds the router by calling `createRouter(database)`
2. Applies request logging middleware
3. Returns the final `Handler` for Shelf

### 3. Route registration
The router defined in `lib/router/router.dart` registers the endpoints:

- `GET /api/health` → health check
- `GET /api/tasks` → fetch tasks
- `POST /api/tasks` → create a new task

It also creates the dependency chain:

- `TaskRepository(database.connection)`
- `TaskService(taskRepository)`
- `TaskController(taskService)`

This is the main wiring point of the app.

### 4. Request handling flow
For a request like `GET /api/tasks`:

1. The request enters the Shelf app
2. `router.get('/api/tasks', taskController.getTasks)` matches the route
3. `TaskController.getTasks()` receives the request
4. It calls `service.getTasks()`
5. The service calls `repository.getTasks()`
6. The repository runs a SQL query against PostgreSQL
7. The result is mapped into `Task` model objects
8. The controller encodes the results as JSON and returns the HTTP response

For a request like `POST /api/tasks`:

1. The controller reads the JSON body
2. Validates `title` and `description`
3. Calls `service.createTask()`
4. Service validates business rules such as empty title and max length
5. Repository inserts the task into the `tasks` table with `INSERT ... RETURNING *`
6. Controller sends back a `201 Created` response with the new task

## Layer Responsibilities

### Database layer
`lib/database/database.dart`

- Builds the PostgreSQL connection using `postgres` package
- Reads values from environment variables such as host, port, database name, user, and password
- Confirms the connection is active

### Environment configuration
`lib/Env/env.dart`

This file loads environment values such as:

- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

The application expects these variables to be available in the environment before the server runs.

### Model layer
`lib/models/task.dart`

The `Task` model represents a single task row from the database:

- `id`
- `title`
- `description`
- `is_completed`
- `created_at`

It includes `fromMap()` and `toMap()` methods for converting database rows to Dart objects and back to JSON.

## API Endpoints

### Health check
- `GET /api/health`
- Returns:

```json
{"status":"ok"}
```

### Get all tasks
- `GET /api/tasks`
- Returns a JSON array of task objects

### Create task
- `POST /api/tasks`
- Request body example:

```json
{
  "user_id": 1,
  "title": "Learn Dart API",
  "description": "Build a small project using Shelf and PostgreSQL"
}
```

Response:

```json
{
  "id": 1,
  "title": "Learn Dart API",
  "description": "Build a small project using Shelf and PostgreSQL",
  "is_completed": false,
  "created_at": "2026-10-12T12:00:00.000Z"
}
```

## Run the project

1. Install dependencies:

```bash
dart pub get
```

2. Set your PostgreSQL environment variables.

3. Start the server:

```bash
dart run bin/server.dart
```

4. The API will be available at:

```text
http://localhost:8050
```

## Summary

This project is a simple layered API where each request flows through the router, controller, service, repository, and PostgreSQL database. It is a good example of a clean Dart REST API structure using `shelf` and `postgres`.

This project is currently under development....
