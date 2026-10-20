
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import 'database_provider.dart';

final shopProvider = FutureProvider<ShopTableData?>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.shopDao.getShop();
});