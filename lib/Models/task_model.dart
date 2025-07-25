import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String schedule; // stored as string like 'HH:mm'

  @HiveField(2)
  String finish; // stored as string like 'HH:mm'

  @HiveField(3)
  int weightage;

  @HiveField(4)
  bool isComplete;

  TaskModel({
    required this.title,
    required this.schedule,
    required this.finish,
    required this.weightage,
    this.isComplete = false,
  });

  // Helper to get TimeOfDay from stored string
  TimeOfDay get scheduleTime => _parseTime(schedule);
  TimeOfDay get finishTime => _parseTime(finish);

  static TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}