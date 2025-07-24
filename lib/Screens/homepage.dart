import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Models/task_model.dart';
import 'package:todo_list/Providers/task_provider.dart';
import 'package:todo_list/Wigets/Bar.dart';
import 'package:todo_list/Wigets/StatusCard.dart';
import '../Wigets/add_task_dialog.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedTabIndex = 0;
  final List<String> taskTitles = [
    "Today's Tasks",
    "Completed Tasks",
    "All Tasks",
    "Overdue Tasks",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: bar( onTabSelected: (index) {
        setState(() => selectedTabIndex = index);
      },),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF9F9FB), // soft pastel base
    shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
    bottomRight: Radius.circular(30),
    ),
    ),
    child: ListView(
    padding: EdgeInsets.zero,
    children: [
    Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [Color(0xFF89CFF0), Color(0xFFB5EAEA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
    ),
    ),
    child: const DrawerHeader(
    padding: EdgeInsets.all(20),
    child: Text(
    "🧠 Task Filters",
    style: TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    ),
    ),
    ),
    ),
    _buildDrawerItem(
    icon: Icons.today,
    label: "Uncomplete (Today)",
    onTap: () {
    setState(() => selectedTabIndex = 0);
    Navigator.of(context).pop();
    },
    ),
    _buildDrawerItem(
    icon: Icons.check_circle,
    label: "Complete",
    onTap: () {
    setState(() => selectedTabIndex = 1);
    Navigator.of(context).pop();
    },
    ),
    _buildDrawerItem(
    icon: Icons.warning_amber_rounded,
    label: "Overdue",
    onTap: () {
    setState(() => selectedTabIndex = 3);
    Navigator.of(context).pop();
    },
    ),
    _buildDrawerItem(
    icon: Icons.list_alt,
    label: "All Tasks",
    onTap: () {
    setState(() => selectedTabIndex = 2);
    Navigator.of(context).pop();
    },
    ),
    ],
    ),
    ),

    body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 STATUS CARDS
            Consumer<TaskProvider>(
              builder: (context, provider, _) => Column(
                children: [
                  Row(
                    children: [
                      Statuscard(
                        label: "Today",
                        count: provider.todayTasks.length,
                        color: Colors.blue,
                        icon: Icons.today,
                        onTap: () => setState(() => selectedTabIndex = 0),
                      ),
                      Statuscard(
                        label: "Complete",
                        count: provider.completedTasks.length,
                        color: Colors.green,
                        icon: Icons.check_circle,
                        onTap: () => setState(() => selectedTabIndex = 1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Statuscard(
                        label: "All",
                        count: provider.allTasks.length,
                        color: Colors.amber,
                        icon: Icons.list,
                        onTap: () => setState(() => selectedTabIndex = 2),
                      ),
                      Statuscard(
                        label: "Overdue",
                        count: provider.overdueTasks.length,
                        color: Colors.redAccent,
                        icon: Icons.warning,
                        onTap: () => setState(() => selectedTabIndex = 3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                taskTitles[selectedTabIndex],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 TASK LIST (Filtered)
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, _) {
                  List<TaskModel> tasks;
                  switch (selectedTabIndex) {
                    case 1:
                      tasks = provider.completedTasks;
                      break;
                    case 2:
                      tasks = provider.allTasks;
                      break;
                    case 3:
                      tasks = provider.overdueTasks;
                      break;
                    default:
                      tasks = provider.todayTasks;
                  }

                  if (tasks.isEmpty) {
                    return const Center(child: Text("No tasks added"));
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: ListView.builder(
                      key: ValueKey<int>(selectedTabIndex), // 🔥 this makes the animation work
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: _buildSlidableTaskTile(context, task, index),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 🔹 FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onSave: ({
                required String title,
                required TimeOfDay schedule,
                required TimeOfDay finish,
                required int weightage,
              }) {
                final newTask = TaskModel(
                  title: title,
                  schedule: schedule,
                  finish: finish,
                  weightage: weightage,
                );
                Provider.of<TaskProvider>(context, listen: false).addtask(newTask);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget _buildDrawerItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Color(0xFF374785)),
    title: Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF24305E),
      ),
    ),
    hoverColor: const Color(0xFFEDE7F6),
    onTap: onTap,
  );
}

Widget _buildSlidableTaskTile(BuildContext context, TaskModel task, int index) {
  return Slidable(
    key: ValueKey(task.title + index.toString()),
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      extentRatio: 0.5,
      children: [
        SlidableAction(
          onPressed: (_) {
            Provider.of<TaskProvider>(context, listen: false).toggleComplete(task);
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.check,
          label: 'Complete',
          borderRadius: BorderRadius.circular(12),
        ),
        SlidableAction(
          onPressed: (_) {
            Provider.of<TaskProvider>(context, listen: false).deleteTask(index);
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListTile(
        title: Text(
          task.title,
          style: task.isComplete
              ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)
              : null,
        ),
        subtitle: Text(
          'Schedule: ${task.schedule.format(context)} | Finish: ${task.finish.format(context)}',
        ),
        trailing: Text('⭐ ${task.weightage}'),
        contentPadding: EdgeInsets.zero,
      ),
    ),
  );
}


