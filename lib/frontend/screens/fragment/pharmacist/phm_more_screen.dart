import 'package:flutter/material.dart';

class PhmMoreScreen extends StatelessWidget {
  const PhmMoreScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Pharmacist More Screen'),
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
