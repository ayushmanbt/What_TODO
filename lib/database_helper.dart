import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import './models/task.dart';
import './models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
        join(
          await getDatabasesPath(),
          'todo.db',
        ),
        version: 1, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
      await db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, isDone INTEGER, taskId INTEGER)");
      return db;
    });
  }

  Future<int> insertTask(Task task) async {
    Database _db = await database();
    int taskId = 0;
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => taskId = value);

    return taskId;
  }

  Future<void> editTaskTitle(int id, String newTitle) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title='$newTitle' WHERE id='$id'");
  }

  Future<void> editTaskDesc(int id, String newDesc) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE tasks SET description='$newDesc' WHERE id='$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id='$id'");
    await _db.rawDelete("DELETE FROM todos WHERE taskId='$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> editTodoState(int id, int state) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todos SET isDone='$state' WHERE id='$id'");
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return new Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
      );
    });
  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.query('todos', where: "taskId=$taskId");
    return List.generate(todoMap.length, (index) {
      return new Todo(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        taskId: todoMap[index]['taskId'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }

  Future<void> deleteTodo(int todoId) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM todos WHERE id='$todoId'");
  }
}
