import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/model/medicine_output_model.dart';
import 'package:pharmace_emp/frontend/provider/medicine_provider.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/stock/medicine_widget.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/stock/sales_search_bar.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../../../provider/shop_provider.dart';

class ManInventoryScreen extends ConsumerStatefulWidget {
  const ManInventoryScreen({super.key});

  @override
  ConsumerState<ManInventoryScreen> createState() => _ManInventoryScreenState();
}

class _ManInventoryScreenState extends ConsumerState<ManInventoryScreen> {
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInventory(page: 0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !_isLoading &&
        _hasMore) {
      _fetchInventory(page: _currentPage + 1);
    }
  }

  Future<void> _fetchInventory({int page = 0}) async {
    final shopId = ref.read(selectedShopProvider)?.id;
    if (shopId == null || shopId.isEmpty) return;

    if (page == 0) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _currentPage = 0;
          _hasMore = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingMore = true;
        });
      }
    }

    try {
      final response = await ref
          .read(inventoryProvider.notifier)
          .fetchAndSyncFromBackend(shopId: shopId, page: page, size: 20);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final fetchedList = response.data ?? [];
        if (mounted) {
          setState(() {
            _hasMore = fetchedList.length >= 20;
            _currentPage = page;
          });
        }
      } else if (mounted &&
          (response.statusCode < 200 || response.statusCode >= 300) &&
          response.message != null &&
          response.message!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error fetching inventory: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  double _calculateTotalWorth(List<MedicineOutputModel> medicines) {
    return medicines.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.stockValue),
    );
  }

  String _formatWorth(double worth) {
    if (worth >= 100000) {
      return '₹${(worth / 100000).toStringAsFixed(2)}L';
    } else if (worth >= 1000) {
      return '₹${(worth / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${worth.toStringAsFixed(2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final inventoryState = ref.watch(inventoryProvider);
    final medicines = inventoryState.allItems;
    final filteredList = inventoryState.filteredItems;
    final totalWorth = _calculateTotalWorth(medicines);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'inventory_fb',
          onPressed: () {},
          child: const Icon(Icons.add, size: 28),
        ),
        body: RefreshIndicator(
          onRefresh: () => _fetchInventory(page: 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Track medicine stock levels, batch statuses, and loose items in this store.',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Metrics Row
                  Row(
                    children: [
                      Text(
                        '${medicines.length}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'medicines · worth',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatWorth(totalWorth),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SalesSearchBar(
                    onChanged: (value) {
                      final query = value.toLowerCase().trim();
                      ref.read(inventoryProvider.notifier).search(query);
                    },
                    onFilterTap: () {
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                        items: const [
                          PopupMenuItem(value: 'all', child: Text('All')),
                          PopupMenuItem(
                            value: 'inStock',
                            child: Text('In Stock'),
                          ),
                          PopupMenuItem(
                            value: 'lowStock',
                            child: Text('Low Stock'),
                          ),
                          PopupMenuItem(
                            value: 'outOfStock',
                            child: Text('Out of Stock'),
                          ),
                          PopupMenuItem(value: 'loose', child: Text('Loose')),
                          PopupMenuItem(
                            value: 'expiring',
                            child: Text('Expiring'),
                          ),
                        ],
                      ).then((value) {
                        if (value != null) {
                          ref.read(inventoryProvider.notifier).filter(value);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Medicine List Container / Loading / Empty State
                  if (_isLoading)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (filteredList.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 48,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No medicines found',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try adjusting your search or filters.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return MedicineWidget(
                            medicineItem: item,
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected ${item.medName}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                          );
                        },
                      ),
                    ),

                  if (_isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
