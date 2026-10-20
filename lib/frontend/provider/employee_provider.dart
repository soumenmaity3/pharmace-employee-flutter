import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';
import 'database_provider.dart';

final employeeProvider = AsyncNotifierProvider<EmployeeNotifier, EmpReturnModel?>(EmployeeNotifier.new);
class EmployeeNotifier extends AsyncNotifier<EmpReturnModel?> {
  @override
  Future<EmpReturnModel?> build() async {
    final db = ref.watch(databaseProvider);
    return await db.employeeDao.getEmployee();
  }
  Future<void> saveEmployee(EmpReturnModel emp) async {
    final db = ref.read(databaseProvider);
    await db.employeeDao.saveEmployee(emp);
    state = AsyncData(emp);
  }

  Future<void> clearEmployee() async {
    final db = ref.read(databaseProvider);
    await db.employeeDao.deleteAll();
    state = const AsyncData(null);
  }

}