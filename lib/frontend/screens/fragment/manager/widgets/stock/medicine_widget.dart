import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../../../../../../backend/model/medicine_output_model.dart';

class MedicineWidget extends StatelessWidget {
  const MedicineWidget({
    super.key,
    this.medicineItem,
    this.medicineName,
    this.manufacturerName,
    this.stockValue,
    this.price,
    this.stockStatus,
    this.isLooseAv,
    this.onTap,
  });

  final MedicineOutputModel? medicineItem;
  final String? medicineName;
  final String? manufacturerName;
  final int? stockValue;
  final double? price;
  final StockStatus? stockStatus;
  final bool? isLooseAv;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedMedicineName =
        medicineItem?.medName ?? medicineName ?? 'Medicine Name';
    final resolvedManufacturerName =
        medicineItem?.manufacturerName ?? manufacturerName ?? 'Manufacturer';
    final resolvedStockValue =
        medicineItem?.stockValue ?? stockValue ?? 0;
    final resolvedPrice = medicineItem?.price ?? price ?? 0.0;
    final resolvedStockStatus =
        medicineItem?.stockStatus ?? stockStatus ?? StockStatus.inStock;
    final resolvedIsLooseAv =
        medicineItem?.isLooseAv ?? isLooseAv ?? false;

    final Color statusColor;

    if (resolvedStockStatus == StockStatus.inStock) {
      statusColor = AppColors.success;
    } else if (resolvedStockStatus == StockStatus.lowStock) {
      statusColor = AppColors.goldDark;
    } else {
      statusColor = AppColors.errorDark;
    }

    String stockStatusText;

    switch (resolvedStockStatus) {
      case StockStatus.inStock:
        stockStatusText = 'In stock';
        break;
      case StockStatus.lowStock:
        stockStatusText = 'Low stock';
        break;
      case StockStatus.expiring:
        stockStatusText = 'Expiring Soon';
        break;
      default:
        stockStatusText = 'Out of stock';
    }

    final formattedPrice = (resolvedPrice % 1 == 0)
        ? resolvedPrice.toInt().toString()
        : resolvedPrice.toStringAsFixed(2);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Medicine icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/inventory_outline.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        statusColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

                if (resolvedIsLooseAv)
                  Positioned(
                    right: -7,
                    bottom: -7,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade800,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? theme.cardColor : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.scissors,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Medicine information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resolvedMedicineName,
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '$resolvedManufacturerName · $resolvedStockValue in stock',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Price + stock status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹$formattedPrice',
                  style: theme.textTheme.titleMedium,
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '•',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 18,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      stockStatusText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

typedef MedicineListWidget = MedicineWidget;
