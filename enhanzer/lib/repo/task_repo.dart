// task_repository.dart
import 'package:enhanzer/database/task_db.dart';
import 'package:enhanzer/models/task_model.dart';
import 'package:sqflite/sqflite.dart';


class TaskRepository {
  final TaskDatabaseHelper _databaseHelper = TaskDatabaseHelper.instance;

  Future<List<Task>> getTasks() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<void> addTask(Task task) async {
    final db = await _databaseHelper.database;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTask(Task task) async {
    final db = await _databaseHelper.database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
