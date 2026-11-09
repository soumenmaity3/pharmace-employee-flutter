import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/backend/auth/secure_storage_service.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';
import 'package:pharmace_emp/frontend/provider/shop_provider.dart';

import 'database_provider.dart';
import 'medicine_provider.dart';

final employeeProvider =
    AsyncNotifierProvider<EmployeeNotifier, EmpBody?>(
      EmployeeNotifier.new,
    );

class EmployeeNotifier extends AsyncNotifier<EmpBody?> {
  @override
  Future<EmpBody?> build() async {
    final db = ref.watch(databaseProvider);
    return await db.employeeDao.getEmployee();
  }

  Future<void> saveEmployee(EmpBody emp) async {
    final db = ref.read(databaseProvider);
    await db.employeeDao.saveEmployee(emp);
    state = AsyncData(emp);
  }

  Future<void> setShiftLogoutStatus(bool isLogOut) async {
    final currentEmp = state.value;
    final db = ref.read(databaseProvider);
    final empId = currentEmp?.id ?? '';
    await db.employeeDao.shiftLogout(empId: empId, isLogOut: isLogOut);
    if (currentEmp != null) {
      state = AsyncData(currentEmp.copyWith(isLogOut: isLogOut));
    } else {
      final updatedEmp = await db.employeeDao.getEmployee();
      state = AsyncData(updatedEmp);
    }
  }

  Future<void> clearEmployee() async {
    try {
      await ApiService().logOutEmployee();
    } catch (_) {}

    final db = ref.read(databaseProvider);
    await db.employeeDao.deleteAll();
    await db.shopDao.deleteAll();
    await db.medicineDao.deleteAllData();
    await SecureStorageService.deleteToken();
    ref.invalidate(shopProvider);
    ref.invalidate(medicineProvider);
    state = const AsyncData(null);
  }
}
