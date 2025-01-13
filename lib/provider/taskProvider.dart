import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/taskModel.dart';

class TaskProvider extends ChangeNotifier {
  final String _tasksKey = 'tasks';

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_tasksKey);
    if (tasksString != null) {
      final List<dynamic> jsonList = jsonDecode(tasksString);
      _tasks = jsonList.map((json) => Task.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(jsonList));
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.name == updatedTask.name);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(Task task) {
    _tasks.removeWhere((t) => t.name == task.name);
    _saveTasks();
    notifyListeners();
  }
}
