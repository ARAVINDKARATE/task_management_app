import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import 'provider/taskProvider.dart';
import 'views/homeScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
