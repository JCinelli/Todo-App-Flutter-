import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoApp/models/task.dart';
import 'package:todoApp/models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(join(await getDatabasesPath(), 'todo.db'),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
      await db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY, taskId INT, title TEXT, isDone INT)");

      return db;
    }, version: 1);
  }

  Future<int> insertTask(Task task) async {
    Database _db = await database();

    int taskId = 0;

    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });

    return taskId;
  }

  Future<void> updateTaskTitle(int idTask, String newTitle) async {
    Database _db = await database();

    await _db
        .rawUpdate("UPDATE tasks SET title = '$newTitle' WHERE id = '$idTask'");
  }

  Future<void> updateTaskDesciption(int idTask, String newDesciption) async {
    Database _db = await database();

    await _db.rawUpdate(
        "UPDATE tasks SET description = '$newDesciption' WHERE id = '$idTask'");
  }

  Future<List<Task>> findAllTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> tasksMap = await _db.query('tasks');

    return List.generate(tasksMap.length, (index) {
      return Task(
          id: tasksMap[index]['id'],
          title: tasksMap[index]['title'],
          description: tasksMap[index]['description']);
    });
  }

  Future<void> deleteTask(int idTask) async {
    Database _db = await database();

    await _db.rawDelete("DELETE FROM tasks WHERE id = '$idTask'");
    await _db.rawDelete("DELETE FROM todos WHERE TaskId = '$idTask'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> findAllTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todosMap =
        await _db.rawQuery("SELECT * FROM todos WHERE taskId = $taskId");

    return List.generate(todosMap.length, (index) {
      return Todo(
        id: todosMap[index]['id'],
        taskId: todosMap[index]['taskId'],
        title: todosMap[index]['title'],
        isDone: todosMap[index]['isDone'],
      );
    });
  }

  Future<void> updateTodoIsDone(int idTodo, int isDone) async {
    Database _db = await database();

    await _db
        .rawUpdate("UPDATE todos SET isDone = '$isDone' WHERE id = '$idTodo'");
  }
}
