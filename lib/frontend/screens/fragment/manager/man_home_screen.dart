import 'package:flutter/material.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/man_inventory_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/activity_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/billing_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/refund_list_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/task_list_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/extra_widget.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/needs_card_widget.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/next_task_widget.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/home/performance_overview_widget.dart';

import '../common/widgets/employee_header_widget.dart';
import '../common/widgets/quick_action_widget.dart';

class ManHomeScreen extends StatelessWidget {
  const ManHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<(IconData, String, Widget)> quickActions = [
      (Icons.shopping_bag_outlined, 'Billing',  BillingScreen()),
      (Icons.refresh, 'Refund',  RefundListScreen()),
      (Icons.task_alt, 'Tasks',  TaskListScreen()),
      (Icons.local_activity_outlined, 'Activity',  ActivityScreen()),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics:  BouncingScrollPhysics(),
          padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      builder: (context) =>  BillingScreen(),
                    ),
                  );
                },
                onBillsTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  BillingScreen(),
                    ),
                  );
                },
                onStockTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  ManInventoryScreen(),
                    ),
                  );
                },
                onStaffTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  TaskListScreen(),
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
              ),
               SizedBox(height: 12),
              SizedBox(
                height: 82,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics:  BouncingScrollPhysics(),
                  itemCount: quickActions.length,
                  separatorBuilder: (context, index) =>  SizedBox(width: 12),
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
}
