import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks Section')),
      body: Center(child: Text('Tasks Screen')),
    );
  }
}
