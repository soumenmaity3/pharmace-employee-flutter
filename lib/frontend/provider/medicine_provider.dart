import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/model/medicine_output_model.dart';
import 'package:pharmace_emp/frontend/database/app_database.dart';
import 'package:pharmace_emp/frontend/provider/shop_provider.dart';

import '../../backend/api_response.dart';
import '../../backend/api_service.dart';
import 'database_provider.dart';

final medicineProvider =
    StateNotifierProvider<MedicineNotifier, InventoryState>((ref) {
      final db = ref.watch(databaseProvider);
      final shopId = ref.watch(shopProvider).value?.id;
      return MedicineNotifier(db, shopId);
    });

final inventoryProvider = medicineProvider;

class MedicineNotifier extends StateNotifier<InventoryState> {
  final AppDatabase db;
  final String? shopId;

  MedicineNotifier(this.db, this.shopId)
    : super(InventoryState(allItems: [], filteredItems: [], search: '')) {
    if (shopId != null && shopId!.isNotEmpty) {
      loadAllMedicines(shopId!);
    }
  }

  Future<void> loadAllMedicines(String currentShopId) async {
    final medicines = await db.medicineDao.getAllMedicines(
      currentShopId,
    );
    final items = medicines.map((item) => item.toOutputModel()).toList();
    state = state.copyWith(allItems: items, filteredItems: items);
  }

  Future<void> syncFromBackend(
      List<MedicineOutputModel> remoteList,
      String currentShopId,
      ) async {
    await db.medicineDao.syncMedicines(remoteList, currentShopId);
    await loadAllMedicines(currentShopId);
  }

  Future<ApiResponse<List<MedicineOutputModel>>> fetchAndSyncFromBackend({
    required String shopId,
    int page = 0,
    int size = 20,
  }) async {
    final response = await ApiService().getInventory(
      shopId: shopId,
      page: page,
      size: size,
    );
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        response.data != null) {
      await syncFromBackend(response.data!, shopId);
    }
    return response;
  }

  Future<void> add(MedicineOutputModel medicineItem) async {
    // 1. Save to SQLite
    await db.medicineDao.insertMedicine(medicineItem);

    // 2. Update Riverpod state
    final updateList = [...state.allItems, medicineItem];

    state = state.copyWith(allItems: updateList, filteredItems: updateList);
  }

  Future<void> updateMedicine(MedicineOutputModel updatedMedicine) async {
    // 1. Save to SQLite
    await db.medicineDao.insertMedicine(updatedMedicine);

    // 2. Update Riverpod state
    final updatedList = state.allItems.map((item) {
      final isMatch = (item.id != null && item.id == updatedMedicine.id) ||
          (item.medName.toLowerCase() == updatedMedicine.medName.toLowerCase() &&
              item.batchNo == updatedMedicine.batchNo);
      return isMatch ? updatedMedicine : item;
    }).toList();

    state = state.copyWith(allItems: updatedList, filteredItems: updatedList);
  }

  void search(String query) {
    final searchQuery = query.toLowerCase().trim();
    state = state.copyWith(
      filteredItems: _searchItem(state.allItems, searchQuery),
      // search: searchQuery,
    );
  }

  List<MedicineOutputModel> _searchItem(
      List<MedicineOutputModel> items,
      String query,
      ) {
    if (query.isEmpty) {
      return items.toList();
    }
    return items.where((item) {
      return item.medName.toLowerCase().contains(query) ||
          item.genericName.toLowerCase().contains(query) ||
          item.brand.toLowerCase().contains(query);
    }).toList();
  }

  void filter(String value) {
    if (value == 'all') {
      state = state.copyWith(filteredItems: state.allItems);
      return;
    } else if (value == 'inStock') {
      state = state.copyWith(filteredItems: _filterItem(state.allItems, value));
      return;
    } else if (value == 'lowStock') {
      state = state.copyWith(filteredItems: _filterItem(state.allItems, value));
      return;
    } else if (value == 'outOfStock') {
      state = state.copyWith(filteredItems: _filterItem(state.allItems, value));
      return;
    } else if (value == 'expiring') {
      state = state.copyWith(filteredItems: _filterItem(state.allItems, value));
      return;
    } else if (value == 'loose') {
      state = state.copyWith(
        filteredItems: state.allItems.where((item) => item.avLoose).toList(),
      );
      return;
    } else {
      state = state.copyWith(filteredItems: state.allItems);
      return;
    }
  }

  List<MedicineOutputModel> _filterItem(
      List<MedicineOutputModel> items,
      String value,
      ) {
    return items.where((item) {
      return item.stockStatus.toString().contains(value);
    }).toList();
  }
}

class InventoryState {
  final List<MedicineOutputModel> allItems;
  final List<MedicineOutputModel> filteredItems;
  final String search;

  InventoryState({
    required this.allItems,
    required this.filteredItems,
    required this.search,
  });

  InventoryState copyWith({
    List<MedicineOutputModel>? allItems,
    List<MedicineOutputModel>? filteredItems,
    String? search,
  }) {
    return InventoryState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      search: search ?? this.search,
    );
  }
}
