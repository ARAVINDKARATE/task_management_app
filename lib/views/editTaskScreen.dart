import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/taskModel.dart';
import '../provider/taskProvider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  DateTime? _dueDate;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _taskName = widget.task.name;
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _taskName,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Task Name is required' : null,
                onSaved: (value) => _taskName = value!,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(
                  _dueDate == null ? 'Select Due Date' : 'Due Date: ${_dueDate.toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  setState(() => _dueDate = date);
                },
              ),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    taskProvider.updateTask(widget.task.copyWith(
                      name: _taskName,
                      dueDate: _dueDate,
                      priority: _priority,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
