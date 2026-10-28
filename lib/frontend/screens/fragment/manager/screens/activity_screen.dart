import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity Section')),
      body: Center(child: Text('Activity Screen')),
    );
  }
}
