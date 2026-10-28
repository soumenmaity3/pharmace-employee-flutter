// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_dao.dart';

// ignore_for_file: type=lint
mixin _$MedicineDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicineTableTable get medicineTable => attachedDatabase.medicineTable;
  MedicineDaoManager get managers => MedicineDaoManager(this);
}

class MedicineDaoManager {
  final _$MedicineDaoMixin _db;
  MedicineDaoManager(this._db);
  $$MedicineTableTableTableManager get medicineTable =>
      $$MedicineTableTableTableManager(_db.attachedDatabase, _db.medicineTable);
}
