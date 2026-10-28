import 'package:flutter/material.dart';

import '../common/widgets/employee_header_widget.dart';


class PhmHomeScreen extends StatelessWidget {
  const PhmHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            SizedBox(height: 16),
            EmployeeHeaderWidget(),
          ],
        ),
      ),
    );
  }
}
