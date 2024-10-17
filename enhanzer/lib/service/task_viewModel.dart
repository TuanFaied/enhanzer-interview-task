// task_view_model.dart
import 'package:enhanzer/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:enhanzer/database/task_db.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await TaskDatabaseHelper.instance.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await TaskDatabaseHelper.instance.insertTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabaseHelper.instance.updateTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabaseHelper.instance.deleteTask(id);
    await fetchTasks();
  }
}
