import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:pharmace_emp/frontend/database/table/employee_table.dart';
import 'package:pharmace_emp/frontend/database/table/shop_table.dart';
import 'package:path_provider/path_provider.dart';

import 'dao/employee/employee_dao.dart';
import 'dao/shop/shop_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [EmployeeTable, ShopTable],daos: [EmployeeDao,ShopDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {},
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pharmace_emp_database',
      native: DriftNativeOptions(
        databaseDirectory: getApplicationDocumentsDirectory,
      ),
    );
  }
}

///flutter pub add drift drift_flutter
// flutter pub add --dev drift_dev build_runner
//
// dart run build_runner build --delete-conflicting-outputs
