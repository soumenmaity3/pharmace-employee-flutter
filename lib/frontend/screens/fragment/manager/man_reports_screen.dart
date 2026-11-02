import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class ManReportsScreen extends ConsumerStatefulWidget {
  const ManReportsScreen({super.key});

  @override
  ConsumerState<ManReportsScreen> createState() => _ManReportsScreenState();
}

class _ManReportsScreenState extends ConsumerState<ManReportsScreen> {
  int _selectedTimeFilter = 1; // 0: Today, 1: This Week, 2: This Month

  final List<String> _timeFilters = [
    'Today',
    'This Week',
    'This Month',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reports & Analytics',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sales and inventory summary',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton.filledTonal(
                    onPressed: _showExportOptionsBottomSheet,
                    icon: const Icon(Icons.file_download_outlined, size: 20),
                    tooltip: 'Export Report',
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Time Range Selector
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _timeFilters.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedTimeFilter == index;
                    return ChoiceChip(
                      label: Text(_timeFilters[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedTimeFilter = index;
                          });
                        }
                      },
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: isSelected
                            ? AppColors.white
                            : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary),
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                      selectedColor:
                      isDark ? AppColors.primaryDark : AppColors.primary,
                      backgroundColor: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurfaceVariant,
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Key Financial Metrics (2 Cards)
              _buildMetricsRow(theme, isDark),

              const SizedBox(height: 16),

              // Sales Category Distribution
              _buildCategoryDistribution(theme, isDark),

              const SizedBox(height: 16),

              // Top Selling Medicines (Top 3)
              _buildTopSellingProducts(theme, isDark),

              const SizedBox(height: 16),

              // Staff Performance Summary (Top 2)
              _buildStaffPerformance(theme, isDark),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsRow(ThemeData theme, bool isDark) {
    final sales = _selectedTimeFilter == 0
        ? '₹18,450'
        : (_selectedTimeFilter == 1 ? '₹1,24,850' : '₹4,86,200');
    final orders = _selectedTimeFilter == 0
        ? '64 Bills'
        : (_selectedTimeFilter == 1 ? '428 Bills' : '1,680 Bills');

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            theme: theme,
            isDark: isDark,
            title: 'Revenue',
            value: sales,
            trend: '+14%',
            icon: Icons.payments_outlined,
            color: isDark ? AppColors.primaryDark : AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            theme: theme,
            isDark: isDark,
            title: 'Total Orders',
            value: orders,
            trend: '+8%',
            icon: Icons.receipt_long_outlined,
            color: isDark ? AppColors.cashierForeground : AppColors.cashierForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required ThemeData theme,
    required bool isDark,
    required String title,
    required String value,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.successDarkContainer
                      : AppColors.successLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.successDark : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution(ThemeData theme, bool isDark) {
    final categories = [
      ('Prescription', 0.65, '₹81,150', AppColors.primary),
      ('OTC Wellness', 0.25, '₹31,210', Colors.blueAccent),
      ('Personal Care', 0.10, '₹12,490', AppColors.gold),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Share',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: categories.map((cat) {
                  return Expanded(
                    flex: (cat.$2 * 100).toInt(),
                    child: Container(color: cat.$4),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: categories.map((cat) {
              final percentage = (cat.$2 * 100).toStringAsFixed(0);
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: cat.$4,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cat.$1,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${cat.$3} ($percentage%)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingProducts(ThemeData theme, bool isDark) {
    final products = [
      ('Paracetamol 500mg', '1,420 Sold', '₹28,400'),
      ('Amoxicillin 250mg', '890 Sold', '₹35,600'),
      ('Vitamin C 500mg', '650 Sold', '₹13,000'),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Products',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < products.length; i++) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products[i].$1,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        products[i].$2,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  products[i].$3,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (i < products.length - 1) const Divider(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildStaffPerformance(ThemeData theme, bool isDark) {
    final staff = [
      ('Alex Johnson', 'Pharmacist', '₹48,900'),
      ('Sarah Smith', 'Cashier', '₹36,250'),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duty Performance',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < staff.length; i++) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isDark
                      ? AppColors.primaryDark.withValues(alpha: 0.3)
                      : AppColors.primaryContainer,
                  child: Text(
                    staff[i].$1[0],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.primaryLight : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff[i].$1,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        staff[i].$2,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  staff[i].$3,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (i < staff.length - 1) const Divider(height: 12),
          ],
        ],
      ),
    );
  }

  void _showExportOptionsBottomSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Export Report',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined, color: Colors.redAccent),
                  title: const Text('Export PDF Statement'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating PDF report...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.table_chart_outlined, color: Colors.green),
                  title: const Text('Export Excel / CSV Sheet'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting CSV spreadsheet...')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
