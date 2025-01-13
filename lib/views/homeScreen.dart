import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/taskProvider.dart';
import 'addTaskScreen.dart';
import 'editTaskScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              toggle(value);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          final formattedDate = task.dueDate != null ? DateFormat('MMM dd, yyyy').format(task.dueDate!) : 'No Due Date';

          return ListTile(
            title: Text(
              task.name,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            subtitle: Text('$formattedDate | ${task.priority}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    task.isCompleted = value ?? false;
                    taskProvider.updateTask(task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditTaskScreen(task: task),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => taskProvider.deleteTask(task),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddTaskScreen()),
        ),
      ),
    );
  }

  void toggle(bool value) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('darkMode', value);
    });
    setState(() {
      _isDarkMode = value;
    });
  }
}
