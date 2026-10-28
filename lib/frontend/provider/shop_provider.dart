import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';

import 'database_provider.dart';

final shopProvider = AsyncNotifierProvider<ShopNotifier, Shop?>(
  ShopNotifier.new,
);

final selectedShopProvider = Provider<Shop?>((ref) {
  return ref.watch(shopProvider).value;
});

class ShopNotifier extends AsyncNotifier<Shop?> {
  @override
  Future<Shop?> build() async {
    final db = ref.watch(databaseProvider);
    return await db.shopDao.getShop();
  }
}
