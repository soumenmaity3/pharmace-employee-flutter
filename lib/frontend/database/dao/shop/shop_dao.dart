import 'dart:async';

import 'package:drift/drift.dart';
import 'package:pharmace_emp/frontend/database/app_database.dart';

import '../../../../backend/model/emp_return_model.dart';
import '../../table/shop_table.dart';

part 'shop_dao.g.dart';

@DriftAccessor(tables: [ShopTable])
class ShopDao extends DatabaseAccessor<AppDatabase> with _$ShopDaoMixin {
  ShopDao(super.db);

  Future<Shop?> getShop() async {
    final shop = await select(shopTable).getSingleOrNull();
    if (shop == null) return null;
    return Shop(
      id: shop.id,
      shopName: shop.shopName,
      shopEmail: shop.shopEmail,
      shopCode: shop.shopCode,
      phone: shop.phone,
      address: shop.address,
      city: shop.city,
      state: shop.state,
      pincode: shop.pincode,
      licenseNumber: shop.licenseNumber,
      gstNumber: shop.gstNumber,
      verifyStatus: Verify.values.firstWhere(
        (status) => status.label == shop.verifyStatus,
        orElse: () => Verify.pending,
      ),
      logoUrl: shop.logoUrl,
      isOpen: shop.isOpen,
      isOwnerEmployee: shop.isOwnerEmployee,
      owner: shop.ownerId != null ? Owner(id: shop.ownerId) : null,
    );
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
    await delete(shopTable).go();
  }
}
