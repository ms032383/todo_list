import 'package:flutter/material.dart';
import 'package:todo_list/Models/task_model.dart';

class TaskProvider with ChangeNotifier{
  final List<TaskModel> _task = [];
  List<TaskModel> get todayTasks =>
      _task.where((task) => !task.isComplete).toList();
  List<TaskModel> get completedTasks =>
      _task.where((task) => task.isComplete).toList();
  List<TaskModel> get overdueTasks =>
      _task.where((task) => _isOverdue(task)).toList();

  List<TaskModel> get allTasks => _task;

  void addtask(TaskModel task){
    _task.add(task);
    notifyListeners();
  }
  void deleteTask(int index) {
    _task.removeAt(index);
    notifyListeners();
  }
  void toggleComplete(TaskModel task) {
    task.isComplete = !task.isComplete;
    notifyListeners();
  }
  bool _isOverdue(TaskModel task) {
    final now = TimeOfDay.now();
    return !task.isComplete &&
        (task.finish.hour < now.hour ||
            (task.finish.hour == now.hour && task.finish.minute < now.minute));
  }

}