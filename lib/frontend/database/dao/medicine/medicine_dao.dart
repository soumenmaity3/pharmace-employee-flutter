import 'package:drift/drift.dart';
import '../../../../backend/model/emp_return_model.dart';
import '../../../../backend/model/medicine_output_model.dart';
import '../../app_database.dart';
import '../../table/medicine_table.dart';

part 'medicine_dao.g.dart';

@DriftAccessor(tables: [MedicineTable])
class MedicineDao extends DatabaseAccessor<AppDatabase>
    with _$MedicineDaoMixin {
  MedicineDao(super.db);

  /// Fetch all cached medicines
  Future<List<MedicineTableData>> getAllMedicines(String shopId) {
    return (select(medicineTable)..where((t) => t.shopId.equals(shopId))).get();
  }

  /// Watch all cached medicines in real-time stream
  Stream<List<MedicineTableData>> watchAllMedicines(String shopId) {
    return (select(medicineTable)..where((t) => t.shopId.equals(shopId))).watch();
  }

  /// Search medicines by medicine name, generic name, or brand
  Future<List<MedicineTableData>> searchMedicines(String query) {
    final cleanQuery = '%${query.toLowerCase().trim()}%';
    return (select(medicineTable)
      ..where((t) =>
          t.medName.lower().like(cleanQuery) |
          t.genericName.lower().like(cleanQuery) |
          t.brand.lower().like(cleanQuery)))
        .get();
  }

  /// Get single medicine by id
  Future<MedicineTableData?> getMedicineById(String id) {
    return (select(medicineTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Bulk sync medicines fetched from API
  Future<void> syncMedicines(List<MedicineOutputModel> medicines, String shopId) async {
    await transaction(() async {
      await batch((b) {
        b.insertAllOnConflictUpdate(
          medicineTable,
          medicines.map((med) => med.toCompanion().copyWith(shopId: Value(shopId))),
        );
      });
    });
  }

  /// Insert from UI MedicineOutputModel
  Future<void> insertMedicine(MedicineOutputModel medicine) {
    return into(medicineTable).insertOnConflictUpdate(medicine.toCompanion());
  }

  /// Insert or update directly with a companion
  Future<void> insertOrUpdateCompanion(MedicineTableCompanion companion) {
    return into(medicineTable).insertOnConflictUpdate(companion);
  }

  /// Delete a medicine by id
  Future<void> deleteMedicine(String id) {
    return (delete(medicineTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Delete all local medicine records
  Future<int> deleteAllMedicines() {
    return delete(medicineTable).go();
  }

  /// Alias for backward compatibility
  Future<int> deleteAllData() => deleteAllMedicines();
}

extension MedicineOutputModelToCompanion on MedicineOutputModel {
  MedicineTableCompanion toCompanion() {
    return MedicineTableCompanion(
      id: Value(id ?? ''),
      medName: Value(medName),
      genericName: Value(genericName),
      brand: Value(brand),
      category: Value(category),
      strength: Value(strength),
      dosageForm: Value(dosageForm.label ?? dosageForm.name),
      schedule: Value(schedule.label ?? schedule.name),
      imageUrl: Value(imageUrl),
      batchNo: Value(batchNo),
      quantity: Value(quantity),
      avLoose: Value(avLoose),
      looseQuantity: Value(looseQuantity),
      totalLooseInStrip: Value(totalLooseInStrip),
      minStockLevel: Value(minStockLevel),
      maxStockLevel: Value(maxStockLevel),
      stockStatus: Value(stockStatus.name),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
      mrp: Value(mrp),
      manufactureDate: Value(manufactureDate),
      expiryDate: Value(expiryDate),
      supplier: Value(supplier),
      addDate: Value(addDate),
      updateDate: Value(updateDate),
      shopId: Value(shop?.id),
      addedBy: Value(addedBy?.id),
      updatedBy: Value(updatedBy?.id),
    );
  }
}

extension MedicineTableDataToOutputModel on MedicineTableData {
  MedicineOutputModel toOutputModel() {
    return MedicineOutputModel(
      id: id,
      medName: medName,
      genericName: genericName,
      brand: brand,
      category: category,
      strength: strength,
      dosageForm: DosageForm.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == dosageForm.toLowerCase() ||
            (e.label != null && e.label!.toLowerCase() == dosageForm.toLowerCase()),
        orElse: () => DosageForm.other,
      ),
      schedule: Schedules.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == schedule.toLowerCase() ||
            (e.label != null && e.label!.toLowerCase() == schedule.toLowerCase()),
        orElse: () => Schedules.none,
      ),
      imageUrl: imageUrl,
      batchNo: batchNo,
      quantity: quantity,
      avLoose: avLoose,
      looseQuantity: looseQuantity ?? 0,
      totalLooseInStrip: totalLooseInStrip ?? 0,
      minStockLevel: minStockLevel,
      maxStockLevel: maxStockLevel,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      mrp: mrp,
      manufactureDate: manufactureDate,
      expiryDate: expiryDate,
      addDate: addDate,
      updateDate: updateDate,
      shop: shopId != null ? Shop(id: shopId!) : null,
      addedBy: addedBy != null ? EmpBody(id: addedBy!, name: addedBy!) : null,
      updatedBy: updatedBy != null ? EmpBody(id: updatedBy!, name: updatedBy!) : null,
      supplier: supplier,
    );
  }
}

