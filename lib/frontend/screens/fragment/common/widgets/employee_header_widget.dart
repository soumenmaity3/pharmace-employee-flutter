import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/frontend/provider/shop_provider.dart';

import '../../../../../backend/model/emp_model_invite_id.dart';
import '../../../../provider/employee_provider.dart';
import '../../../../theme/app_colors.dart';

class EmployeeHeaderWidget extends ConsumerWidget {
  const EmployeeHeaderWidget({super.key});

  Color badgeForegroundColor(RoleEmp role) {
    switch (role) {
      case RoleEmp.manager:
        return AppColors.managerPurpleBackground;
      case RoleEmp.pharmacist:
        return AppColors.pharmacistBadgeBackground;
      case RoleEmp.cashier:
        return AppColors.cashierBadgeBackground;
      default:
        return AppColors.staffBadgeBackground;
    }
  }

  RoleEmp getRole(String role) {
    switch (role) {
      case 'Manager':
        return RoleEmp.manager;
      case 'Pharmacist':
        return RoleEmp.pharmacist;
      case 'Cashier':
        return RoleEmp.cashier;
      default:
        return RoleEmp.staff;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(employeeProvider);
    final shop = ref.watch(shopProvider);
    final empData = employee.value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (empData == null) {
      return const SizedBox.shrink();
    }

    final isOpen = empData.shop?.isOpen ?? false;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Employee avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.managerAvatarColor,
            child: Text(
              getInitials(empData.name),
              style: const TextStyle(
                color: AppColors.managerPurpleForeground,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Employee information takes only the available space.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Long names are truncated with ...
                Text(
                  empData.name.trim().isNotEmpty ? empData.name.trim() : ' ',
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  // style: const TextStyle(
                  //   color: AppColors.darkTextPrimary,
                  //   fontSize: 18,
                  //   fontWeight: FontWeight.w700,
                  //   height: 1.25,
                  //   letterSpacing: -0.2,
                  // ),
                ),

                const SizedBox(height: 4),

                // Shop name also truncates when too long.
                Text(
                  shop.value?.shopName ?? '',
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 7),

                // Employee role and duty status
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    buildBadge(
                      background: badgeForegroundColor(getRole(empData.role!)),
                      foreground: AppColors.managerPurpleForeground,
                      icon: Icons.shield_outlined,
                      label: empData.role!,
                      isDark: isDark
                    ),
                    buildBadge(
                      background: AppColors.managerGreenBackground,
                      foreground: AppColors.managerGreenForeground,
                      icon: Icons.circle,
                      label: 'On Duty',
                      iconSize: 7,
                      isDark: isDark
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Shop status stays at the far right.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: isOpen
                  ? AppColors.successDarkContainer.withValues(
                      alpha: isDark ? 1 : 0.7,
                    )
                  : AppColors.errorDarkContainer.withValues(
                      alpha: isDark ? 1 : 0.7,
                    ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.storefront_outlined,
                  size: 16,
                  color: isOpen ? AppColors.successDark : AppColors.errorDark,
                ),
                const SizedBox(width: 5),
                Text(
                  isOpen ? 'Open' : 'Closed',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isOpen ? AppColors.successDark : AppColors.errorDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildBadge({
    required Color background,
    required Color foreground,
    required IconData icon,
    required String label,
    double iconSize = 14,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background.withValues(
          alpha: isDark ? 1 : 0.7,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
