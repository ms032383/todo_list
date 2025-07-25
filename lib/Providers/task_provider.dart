import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/Models/task_model.dart';

import '../Services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  Box<TaskModel> taskBox = Hive.box<TaskModel>('tasks');

  List<TaskModel> get allTasks => taskBox.values.toList();

  List<TaskModel> get todayTasks =>
      allTasks.where((task) => !task.isComplete).toList();

  List<TaskModel> get completedTasks =>
      allTasks.where((task) => task.isComplete).toList();

  List<TaskModel> get overdueTasks {
    final now = TimeOfDay.now();
    return todayTasks.where((task) {
      final finish = task.finishTime;
      return finish.hour < now.hour || (finish.hour == now.hour && finish.minute < now.minute);
    }).toList();
  }


  void addtask(TaskModel task) async {
    await taskBox.add(task);

    // Schedule notification
    DateTime? scheduleDateTime = _parseTimeToDateTime(task.schedule);
    if (scheduleDateTime != null) {
      await NotificationService.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Task Reminder',
        body: 'Reminder: ${task.title}',
        scheduledTime: scheduleDateTime,
      );
    }

    notifyListeners();
  }
  void deleteTask(int index) async {
    await taskBox.deleteAt(index);
    notifyListeners();
  }

  void toggleComplete(TaskModel task) {
    task.isComplete = !task.isComplete;
    task.save();
    notifyListeners();
  }
}

DateTime? _parseTimeToDateTime(String timeStr) {
  try {
    final now = DateTime.now();
    final parts = timeStr.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(now.year, now.month, now.day, hour, minute);
  } catch (e) {
    return null;
  }
}