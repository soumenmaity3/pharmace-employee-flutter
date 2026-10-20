// lib/frontend/provider/database_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/frontend/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});