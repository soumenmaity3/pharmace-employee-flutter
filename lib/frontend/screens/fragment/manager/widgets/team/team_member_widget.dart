import 'package:flutter/material.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../../../common/widgets/employee_header_widget.dart';

class TeamMemberWidget extends StatelessWidget {
  const TeamMemberWidget({
    super.key,
    required this.name,
    required this.designation,
    required this.email,
    required this.role,
    required this.isOnDuty,
    required this.onMarkInactive,
  });

  final String name;
  final String designation;
  final String email;
  final String role;
  final bool isOnDuty;
  final VoidCallback? onMarkInactive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleLarge),
                    SizedBox(height: 5),
                    Text(
                      designation,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isOnDuty
                      ? (isDark
                            ? AppColors.successDarkContainer
                            : AppColors.successLight)
                      : (isDark
                            ? AppColors.errorDarkContainer
                            : AppColors.errorLight),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnDuty
                            ? (isDark
                                  ? AppColors.successDark
                                  : AppColors.success)
                            : (isDark ? AppColors.errorDark : AppColors.error),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOnDuty ? 'On duty' : 'Inactive',
                      style: TextStyle(
                        color: isOnDuty
                            ? (isDark
                                  ? AppColors.successDark
                                  : AppColors.success)
                            : (isDark ? AppColors.errorDark : AppColors.error),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Builder(
            builder: (context) {
              final (bg, fg, iconData) = _getRoleColors(role, isDark);
              return EmployeeHeaderWidget.buildBadge(
                background: bg,
                foreground: fg,
                icon: iconData,
                label: role,
                isDark: isDark,
              );
            },
          ),
          SizedBox(height: 15),
          Text(
            email,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: 17),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              onPressed: isOnDuty ? onMarkInactive : null,
              style: theme.outlinedButtonTheme.style?.copyWith(),
              child: Text(
                'Mark inactive',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, IconData) _getRoleColors(String role, bool isDark) {
    switch (role.toLowerCase()) {
      case 'manager':
        return (
          isDark
              ? AppColors.managerPurpleBackground
              : AppColors.managerBackground,
          isDark
              ? AppColors.managerPurpleForeground
              : AppColors.managerForeground,
          Icons.shield_outlined,
        );
      case 'pharmacist':
        return (
          isDark
              ? AppColors.pharmacistBadgeBackground
              : AppColors.pharmacistBackground,
          isDark
              ? AppColors.pharmacistBadgeForeground
              : AppColors.pharmacistForeground,
          Icons.medical_services_outlined,
        );
      case 'cashier':
        return (
          isDark
              ? AppColors.cashierBadgeBackground
              : AppColors.cashierBackground,
          isDark
              ? AppColors.cashierBadgeForeground
              : AppColors.cashierForeground,
          Icons.point_of_sale_outlined,
        );
      default:
        return (
          isDark ? AppColors.staffBadgeBackground : AppColors.staffBackground,
          isDark ? AppColors.staffBadgeForeground : AppColors.staffForeground,
          Icons.badge_outlined,
        );
    }
  }
}
