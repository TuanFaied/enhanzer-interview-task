// task_view_model.dart
import 'package:enhanzer/models/task_model.dart';
import 'package:enhanzer/repo/task_repo.dart';
import 'package:flutter/material.dart';
import 'package:enhanzer/database/task_db.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  final TaskRepository _taskRepository = TaskRepository();
  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await _taskRepository.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _taskRepository.addTask(task);
    await fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskRepository.updateTask(task);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    await fetchTasks();
  }
}
