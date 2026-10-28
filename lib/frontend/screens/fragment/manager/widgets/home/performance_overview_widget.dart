import 'package:flutter/material.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class PerformanceOverviewWidget extends StatelessWidget {
  const PerformanceOverviewWidget({
    super.key,
    this.totalSales = '₹24,850',
    this.salesTrend = '+12.4%',
    this.staffOnDuty = '4 / 5',
    this.staffStatus = 'Active now',
    this.billsCount = '86',
    this.billsSubtext = 'Avg. ₹289',
    this.lowStockCount = '3 items',
    this.stockSubtext = 'Needs reorder',
    this.onSalesTap,
    this.onStaffTap,
    this.onBillsTap,
    this.onStockTap,
  });

  final String totalSales;
  final String salesTrend;
  final String staffOnDuty;
  final String staffStatus;
  final String billsCount;
  final String billsSubtext;
  final String lowStockCount;
  final String stockSubtext;

  final VoidCallback? onSalesTap;
  final VoidCallback? onStaffTap;
  final VoidCallback? onBillsTap;
  final VoidCallback? onStockTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Section label + Live indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:  EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? 0.25 : 0.12,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Icon(
                      Icons.insights_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                   SizedBox(width: 8),
                  Text(
                    'Performance Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              // Live status badge
              Container(
                padding:  EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (isDark
                          ? AppColors.successDarkContainer
                          : AppColors.successLight)
                      .withValues(alpha: isDark ? 1.0 : 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration:  BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                     SizedBox(width: 5),
                    Text(
                      'Live',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.successDark
                            : AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

           SizedBox(height: 14),

          // 4-part quadrant container (2 rows x 2 cols)
          Row(
            children: [
              // 1. Total Sales
              Expanded(
                child: _buildMetricTile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.trending_up_rounded,
                  iconColor: isDark
                      ? AppColors.successDark
                      : AppColors.success,
                  iconBgColor: (isDark
                          ? AppColors.successDarkContainer
                          : AppColors.successLight)
                      .withValues(alpha: 0.8),
                  label: 'Total Sales',
                  value: totalSales,
                  badgeText: salesTrend,
                  badgeColor: isDark
                      ? AppColors.successDark
                      : AppColors.success,
                  badgeBgColor: (isDark
                          ? AppColors.successDarkContainer
                          : AppColors.successLight)
                      .withValues(alpha: 0.8),
                  onTap: onSalesTap,
                ),
              ),
               SizedBox(width: 10),
              // 2. Staff on Duty
              Expanded(
                child: _buildMetricTile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.people_outline_rounded,
                  iconColor: isDark
                      ? AppColors.managerPurpleForeground
                      : AppColors.managerForeground,
                  iconBgColor: (isDark
                          ? AppColors.managerPurpleBackground
                          : AppColors.managerBackground)
                      .withValues(alpha: 0.8),
                  label: 'Staff on Duty',
                  value: staffOnDuty,
                  badgeText: staffStatus,
                  badgeColor: isDark
                      ? AppColors.managerPurpleForeground
                      : AppColors.managerForeground,
                  badgeBgColor: (isDark
                          ? AppColors.managerPurpleBackground
                          : AppColors.managerBackground)
                      .withValues(alpha: 0.8),
                  onTap: onStaffTap,
                ),
              ),
            ],
          ),

           SizedBox(height: 10),

          Row(
            children: [
              // 3. Bills / Orders
              Expanded(
                child: _buildMetricTile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.receipt_long_outlined,
                  iconColor: isDark
                      ? AppColors.cashierBadgeForeground
                      : AppColors.cashierForeground,
                  iconBgColor: (isDark
                          ? AppColors.cashierBadgeBackground
                          : AppColors.cashierBackground)
                      .withValues(alpha: 0.8),
                  label: 'Bills Today',
                  value: billsCount,
                  badgeText: billsSubtext,
                  badgeColor: textSecondary,
                  badgeBgColor: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  onTap: onBillsTap,
                ),
              ),
               SizedBox(width: 10),
              // 4. Low Stock Alerts
              Expanded(
                child: _buildMetricTile(
                  context: context,
                  isDark: isDark,
                  icon: Icons.warning_amber_rounded,
                  iconColor: isDark
                      ? AppColors.warningDark
                      : AppColors.warning,
                  iconBgColor: (isDark
                          ? AppColors.warningDarkContainer
                          : AppColors.warningLight)
                      .withValues(alpha: 0.8),
                  label: 'Low Stock',
                  value: lowStockCount,
                  badgeText: stockSubtext,
                  badgeColor: isDark
                      ? AppColors.warningDark
                      : AppColors.warning,
                  badgeBgColor: (isDark
                          ? AppColors.warningDarkContainer
                          : AppColors.warningLight)
                      .withValues(alpha: 0.8),
                  onTap: onStockTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBgColor,
    VoidCallback? onTap,
  }) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor.withValues(alpha: isDark ? 0.6 : 0.8),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and optional badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: iconColor,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 10),
              // Value
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
               SizedBox(height: 2),
              // Label
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
