import 'package:flutter/material.dart';

class StfMoreScreen extends StatelessWidget {
  const StfMoreScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Staff More Screen'),
          if (onLogout != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onLogout,
              child: const Text('Logout'),
            ),
          ],
        ],
      ),
    );
  }
}
