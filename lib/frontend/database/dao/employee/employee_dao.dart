import 'package:drift/drift.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';
import 'package:pharmace_emp/frontend/database/app_database.dart';

import '../../table/employee_table.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [EmployeeTable])
class EmployeeDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  Future<EmpReturnModel?> getEmployee() async {
    final employee = await select(employeeTable).getSingleOrNull();
    if (employee == null) return null;
    return EmpReturnModel(
      body: EmpBody(
        id: employee.id,
        name: employee.name,
        email: employee.email,
        password: '',
        role: employee.role,
        isFromOwner: employee.isFromOwner,
        createdAt: employee.createdAt,
      ),
    );
    // shop: employee.shopId));
  }

  Future<void> saveEmployee(EmpReturnModel employee) async {
    final emp = employee.body;
    if (emp == null) return;
    await transaction(() async {
      await delete(employeeTable).go();
      await into(employeeTable).insert(
        EmployeeTableCompanion.insert(
          id: emp.id,
          name: emp.name,
          email: emp.email,
          isFromOwner: Value(emp.isFromOwner),
          role: Value(emp.role),
          shopId: Value(emp.shop?.id),
          createdAt: emp.createdAt,
        ),
      );
    });
  }

  Future<void> deleteAll() async {
    delete(employeeTable).go();
  }
}
