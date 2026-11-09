import 'package:drift/drift.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';
import 'package:pharmace_emp/frontend/database/app_database.dart';

import '../../table/employee_table.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [EmployeeTable])
class EmployeeDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  Future<EmpBody?> getEmployee() async {
    final employee = await select(employeeTable).getSingleOrNull();
    if (employee == null) return null;
    return EmpBody(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      password: '',
      role: employee.role,
      isFromOwner: employee.isFromOwner,
      isLogOut: employee.isLogOut,
      createdAt: employee.createdAt,
    );
  }

  Future<void> saveEmployee(EmpBody employee) async {
    final emp = employee;
    await transaction(() async {
      await delete(employeeTable).go();
      await into(employeeTable).insert(
        EmployeeTableCompanion.insert(
          id: emp.id,
          name: emp.name,
          email: emp.email ?? '',
          isFromOwner: Value(emp.isFromOwner ?? true),
          role: Value(emp.role ?? 'Manager'),
          shopId: Value(emp.shop?.id),
          isLogOut: Value(emp.isLogOut ?? false),
          createdAt: emp.createdAt ?? DateTime.now().toIso8601String(),
        ),
      );
    });
  }

  Future<void> shiftLogout({required String empId, required bool isLogOut}) async {
    if (empId.isNotEmpty) {
      await (update(employeeTable)..where((t) => t.id.equals(empId))).write(
        EmployeeTableCompanion(isLogOut: Value(isLogOut)),
      );
    } else {
      await update(employeeTable).write(
        EmployeeTableCompanion(isLogOut: Value(isLogOut)),
      );
    }
  }

  Future<void> deleteAll() async {
    await delete(employeeTable).go();
  }
}
