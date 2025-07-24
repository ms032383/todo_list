import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final Function({
  required String title,
  required TimeOfDay schedule,
  required TimeOfDay finish,
  required int weightage,
  }) onSave;

  const AddTaskDialog({super.key, required this.onSave});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  TimeOfDay? scheduleTime;
  TimeOfDay? finishTime;
  int weightage = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
                onChanged: (val) => title = val,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Schedule: '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => scheduleTime = picked);
                    },
                    child: Text(scheduleTime?.format(context) ?? 'Select'),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Finish: '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => finishTime = picked);
                    },
                    child: Text(finishTime?.format(context) ?? 'Select'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Weightage (1–5)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final w = int.tryParse(value ?? '');
                  if (w == null || w < 1 || w > 5) return 'Enter 1–5';
                  return null;
                },
                onChanged: (val) => weightage = int.tryParse(val) ?? 1,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                scheduleTime != null &&
                finishTime != null) {
              widget.onSave(
                title: title,
                schedule: scheduleTime!,
                finish: finishTime!,
                weightage: weightage,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}