import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String schedule;

  @HiveField(2)
  String finish;

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
}
