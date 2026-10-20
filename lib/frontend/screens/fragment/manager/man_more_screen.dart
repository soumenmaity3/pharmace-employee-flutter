import 'package:flutter/material.dart';

class ManMoreScreen extends StatelessWidget {
  const ManMoreScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: onLogout, child: Text('Logout')),
    );
  }
}
