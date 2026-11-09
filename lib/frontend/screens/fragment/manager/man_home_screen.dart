import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/frontend/provider/app_view_provider.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/man_inventory_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/activity_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/billing_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/refund_list_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/task_list_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/extra_widget.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/needs_card_widget.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/next_task_widget.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/performance_overview_widget.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../../../provider/employee_provider.dart';
import '../common/widgets/employee_header_widget.dart';
import '../common/widgets/quick_action_widget.dart';

class ManHomeScreen extends ConsumerWidget {
  const ManHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<(IconData, String, Widget)> quickActions = [
      (Icons.shopping_bag_outlined, 'Billing', BillingScreen()),
      (Icons.refresh, 'Refund', RefundListScreen()),
      (Icons.task_alt, 'Tasks', TaskListScreen()),
      (Icons.local_activity_outlined, 'Activity', ActivityScreen()),
    ];
    final employee = ref.watch(employeeProvider).value;

    return (employee?.isLogOut ?? true)
        ? _buildLoggedOutState(context, ref)
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Employee & Store Header
                    EmployeeHeaderWidget(),

                    SizedBox(height: 16),

                    // 2. 4-Part Performance Overview Widget (Top of NeedsCardWidget)
                    PerformanceOverviewWidget(
                      totalSales: '₹24,850',
                      salesTrend: '+12.4%',
                      staffOnDuty: '4 / 5',
                      staffStatus: 'Active',
                      billsCount: '86',
                      billsSubtext: 'Avg. ₹289',
                      lowStockCount: '3 items',
                      stockSubtext: 'Needs reorder',
                      onSalesTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BillingScreen(),
                          ),
                        );
                      },
                      onBillsTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BillingScreen(),
                          ),
                        );
                      },
                      onStockTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ManInventoryScreen(),
                          ),
                        );
                      },
                      onStaffTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskListScreen(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    // 3. Needs Card (Action Required / Refunds)
                    NeedsCardWidget(),

                    SizedBox(height: 18),

                    // 4. Quick Actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 82,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: quickActions.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final item = quickActions[index];
                          return QuickActionWidget(
                            icon: item.$1,
                            label: item.$2,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => item.$3,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 18),

                    // 5. Next Task
                    NextTaskWidget(),

                    SizedBox(height: 16),

                    // 6. Operational Extra Stats
                    ExtraWidget(),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildLoggedOutState(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Shift Ended',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your shift for today has ended. You can resume your shift or log out of your account below.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () async {
                    await ref
                        .read(employeeProvider.notifier)
                        .setShiftLogoutStatus(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(220, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 22),
                  label: const Text(
                    'Resume Shift',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(employeeProvider.notifier).clearEmployee();
                    ref.read(selectedNavIndexProvider.notifier).state = 0;
                    ref.read(appViewProvider.notifier).state = AppView.login;
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.errorDark : AppColors.error,
                    side: BorderSide(
                      color: isDark ? AppColors.errorDark : AppColors.error,
                    ),
                    minimumSize: const Size(220, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'Logout Account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

