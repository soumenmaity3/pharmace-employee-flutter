import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../../provider/app_view_provider.dart';
import '../../provider/database_provider.dart';
import '../../provider/employee_provider.dart';
import '../../screens/fragment/cashier/cashier_billing_screen.dart';
import '../../screens/fragment/cashier/cashier_drawer_screen.dart';
import '../../screens/fragment/cashier/cashier_home_screen.dart';
import '../../screens/fragment/cashier/cashier_more_screen.dart';
import '../../screens/fragment/cashier/cashier_stock_screen.dart';
import '../../screens/fragment/manager/man_home_screen.dart';
import '../../screens/fragment/manager/man_inventory_screen.dart';
import '../../screens/fragment/manager/man_more_screen.dart';
import '../../screens/fragment/manager/man_reports_screen.dart';
import '../../screens/fragment/manager/man_team_screen.dart';
import '../../screens/fragment/pharmacist/phm_home_screen.dart';
import '../../screens/fragment/pharmacist/phm_more_screen.dart';
import '../../screens/fragment/pharmacist/phm_scripts_screen.dart';
import '../../screens/fragment/pharmacist/phm_stock_screen.dart';
import '../../screens/fragment/pharmacist/phm_tasks_screen.dart';
import '../../screens/fragment/staff/stf_home_screen.dart';
import '../../screens/fragment/staff/stf_inward_screen.dart';
import '../../screens/fragment/staff/stf_more_screen.dart';
import '../../screens/fragment/staff/stf_stock_screen.dart';
import '../../screens/fragment/staff/stf_tasks_screen.dart';

enum UserRole { manager, pharmacist, cashier, staff }

class NavItem {
  final String label;
  final Widget icon;
  final Widget? selectedIcon;
  final Widget screen;

   NavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    required this.screen,
  });
}

List<NavItem> navItemsForRole(UserRole role, WidgetRef ref,BuildContext context) {
  Widget buildStockIcon() {
    return SvgPicture.asset(
      'assets/icons/inventory_outline.svg',
      width: 24,
      height: 24,
      color: AppColors.white,
    );
  }

  switch (role) {
    case UserRole.manager:
      return [
         NavItem(
          label: 'Home',
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_outlined),
          screen: ManHomeScreen(),
        ),
         NavItem(
          label: 'Team',
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people_outline),
          screen: ManTeamScreen(),
        ),
        NavItem(
          label: 'Stock',
          icon: buildStockIcon(),
          selectedIcon: buildStockIcon(),
          screen:  ManInventoryScreen(),
        ),
         NavItem(
          label: 'Reports',
          icon: FaIcon(FontAwesomeIcons.clipboard),
          selectedIcon: FaIcon(FontAwesomeIcons.clipboard),
          screen: ManReportsScreen(),
        ),
        NavItem(
          label: 'More',
          icon:  Icon(Icons.menu),
          selectedIcon:  Icon(Icons.menu),
          screen: ManMoreScreen(onLogout: () {
            final db= ref.read(databaseProvider);
            db.employeeDao.deleteAll();
            db.shopDao.deleteAll();
            ref.invalidate(employeeProvider);
            ref.read(appViewProvider.notifier).state = AppView.login;
          },),
        ),
      ];

    case UserRole.pharmacist:
      return [
         NavItem(
          label: 'Home',
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_outlined),
          screen: PhmHomeScreen(),
        ),
         NavItem(
          label: 'Scripts',
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long_rounded),
          screen: PhmScriptsScreen(),
        ),
        NavItem(
          label: 'Stock',
          icon: buildStockIcon(),
          selectedIcon: buildStockIcon(),
          screen:  PhmStockScreen(),
        ),
         NavItem(
          label: 'Tasks',
          icon: FaIcon(FontAwesomeIcons.listCheck),
          selectedIcon: FaIcon(FontAwesomeIcons.listCheck),
          screen: PhmTasksScreen(),
        ),
         NavItem(
          label: 'More',
          icon: Icon(Icons.menu),
          selectedIcon: Icon(Icons.menu),
          screen: PhmMoreScreen(),
        ),
      ];

    case UserRole.cashier:
      return [
         NavItem(
          label: 'Home',
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_outlined),
          screen: CashierHomeScreen(),
        ),
         NavItem(
          label: 'Checkout',
          icon: FaIcon(FontAwesomeIcons.shopify),
          selectedIcon: FaIcon(FontAwesomeIcons.shopify),
          screen: CashierBillingScreen(),
        ),
         NavItem(
          label: 'Drawer',
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet_outlined),
          screen: CashierDrawerScreen(),
        ),
        NavItem(
          label: 'Stock',
          icon: buildStockIcon(),
          selectedIcon: buildStockIcon(),
          screen:  CashierStockScreen(),
        ),
         NavItem(
          label: 'More',
          icon: Icon(Icons.menu),
          selectedIcon: Icon(Icons.menu),
          screen: CashierMoreScreen(),
        ),
      ];

    case UserRole.staff:
      return [
         NavItem(
          label: 'Home',
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_outlined),
          screen: StfHomeScreen(),
        ),
         NavItem(
          label: 'Tasks',
          icon: FaIcon(FontAwesomeIcons.listCheck),
          selectedIcon: FaIcon(FontAwesomeIcons.listCheck),
          screen: StfTasksScreen(),
        ),
         NavItem(
          label: 'Inward',
          icon: Icon(Icons.move_to_inbox_outlined),
          selectedIcon: Icon(Icons.move_to_inbox_outlined),
          screen: StfInwardScreen(),
        ),
        NavItem(
          label: 'Stock',
          icon: buildStockIcon(),
          selectedIcon: buildStockIcon(),
          screen:  StfStockScreen(),
        ),
         NavItem(
          label: 'More',
          icon: Icon(Icons.more_horiz_outlined),
          selectedIcon: Icon(Icons.more_horiz_rounded),
          screen: StfMoreScreen(),
        ),
      ];
  }
}
