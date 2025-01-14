import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/taskModel.dart';
import '../provider/taskProvider.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isDarkMode; // Accept isDarkMode as a parameter

  const AddTaskScreen({required this.isDarkMode, Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _taskName = '';
  DateTime? _dueDate;
  String _priority = 'Medium';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
        theme: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: Text('Add Task')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.colorScheme.primary),
                      ),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'Task Name is required' : null,
                    onSaved: (value) => _taskName = value!,
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      _dueDate == null ? 'Select Due Date' : 'Due Date: ${_dueDate.toString().split(' ')[0]}',
                      style: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                    trailing: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      setState(() {
                        _dueDate = date;
                      });
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
                    onChanged: (value) => setState(() {
                      _priority = value!;
                    }),
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(
                      'Add Task',
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _formKey.currentState?.save();
                        final newTask = Task(
                          name: _taskName,
                          dueDate: _dueDate,
                          priority: _priority,
                        );
                        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
