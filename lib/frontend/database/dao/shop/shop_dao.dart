import 'package:drift/drift.dart';
import 'package:pharmace_emp/frontend/database/app_database.dart';

import '../../../../backend/model/emp_return_model.dart';
import '../../table/shop_table.dart';

part 'shop_dao.g.dart';

@DriftAccessor(tables: [ShopTable])
class ShopDao extends DatabaseAccessor<AppDatabase> with _$ShopDaoMixin {
  ShopDao(super.db);

  Future<ShopTableData?> getShop()async{
    return await select(shopTable).getSingleOrNull();
  }

  Future<void> saveShop(EmpReturnModel employee) async {
    final shop = employee.body?.shop;
    if (shop == null) return;

    await transaction(() async {
      await delete(shopTable).go();
      await into(shopTable).insert(
        ShopTableCompanion(
          id: Value(shop.id ?? ''),
          shopName: Value(shop.shopName ?? ''),
          shopEmail: Value(shop.shopEmail ?? ''),
          shopCode: Value(shop.shopCode ?? ''),
          phone: Value(shop.phone ?? ''),
          address: Value(shop.address ?? ''),
          city: Value(shop.city ?? ''),
          state: Value(shop.state ?? ''),
          pincode: Value(shop.pincode ?? ''),
          licenseNumber: Value(shop.licenseNumber),
          gstNumber: Value(shop.gstNumber),
          verifyStatus: Value(shop.verifyStatus?.label ?? 'Pending'),
          logoUrl: Value(shop.logoUrl),
          isOpen: Value(shop.isOpen),
          ownerId: Value(shop.owner?.id),
          isOwnerEmployee: Value(shop.isOwnerEmployee ?? false),
        ),
      );
    });
  }
  Future<void> deleteAll() async {
    delete(shopTable).go();
  }
}
