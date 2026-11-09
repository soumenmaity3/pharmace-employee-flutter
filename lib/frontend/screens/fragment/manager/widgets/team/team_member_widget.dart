import 'package:flutter/material.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../../../common/widgets/employee_header_widget.dart';

class TeamMemberWidget extends StatelessWidget {
  const TeamMemberWidget({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.isOnDuty,
    this.isFromOwner = false,
    this.isOwnAccount = false,
    required this.onMarkInactive,
    this.onSendMessage,
  });

  final String name;
  final String email;
  final String role;
  final bool isOnDuty;
  final bool isFromOwner;
  final bool isOwnAccount;
  final VoidCallback? onMarkInactive;
  final VoidCallback? onSendMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
                  children: [Text(name, style: theme.textTheme.titleLarge)],
                ),
              ),
              if (!isFromOwner)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOnDuty
                        ? (isDark
                              ? AppColors.successDarkContainer
                              : AppColors.successLight)
                        : (isDark
                              ? AppColors.errorDarkContainer
                              : AppColors.errorLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isOnDuty
                              ? (isDark
                                    ? AppColors.successDark
                                    : AppColors.success)
                              : (isDark
                                    ? AppColors.errorDark
                                    : AppColors.error),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOnDuty ? 'On duty' : 'Inactive',
                        style: TextStyle(
                          color: isOnDuty
                              ? (isDark
                                    ? AppColors.successDark
                                    : AppColors.success)
                              : (isDark
                                    ? AppColors.errorDark
                                    : AppColors.error),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
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
              if (isFromOwner)
                EmployeeHeaderWidget.buildBadge(
                  background: isDark
                      ? AppColors.goldDarkContainer
                      : AppColors.goldLight,
                  foreground: isDark ? AppColors.goldDark : AppColors.gold,
                  icon: Icons.shield_rounded,
                  label: 'Owner',
                  isDark: isDark,
                ),
              if (isOwnAccount)
                EmployeeHeaderWidget.buildBadge(
                  background: isDark
                      ? AppColors.managerPurpleBackground
                      : AppColors.managerBackground,
                  foreground: isDark
                      ? AppColors.managerPurpleForeground
                      : AppColors.managerForeground,
                  icon: Icons.person_pin_rounded,
                  label: 'You',
                  isDark: isDark,
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: (isFromOwner || isOwnAccount)
                        ? onMarkInactive
                        : (isOnDuty ? onMarkInactive : null),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isFromOwner
                            ? (isDark ? AppColors.goldDark : AppColors.gold)
                            : isOwnAccount
                                ? (isDark
                                      ? AppColors.managerPurpleForeground
                                      : AppColors.managerForeground)
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isFromOwner
                          ? 'Owner Account'
                          : isOwnAccount
                              ? 'Your Account'
                              : 'Mark inactive',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isFromOwner
                            ? (isDark ? AppColors.goldDark : AppColors.gold)
                            : isOwnAccount
                                ? (isDark
                                      ? AppColors.managerPurpleForeground
                                      : AppColors.managerForeground)
                                : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: onSendMessage,
                    icon: Icon(
                      isFromOwner
                          ? Icons.report_problem_outlined
                          : isOwnAccount
                              ? Icons.person_outline_rounded
                              : Icons.task_alt_outlined,
                      size: 18,
                    ),
                    label: Text(
                      isFromOwner
                          ? 'Complaint'
                          : isOwnAccount
                              ? 'Profile'
                              : 'Assign Task',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFromOwner
                          ? (isDark
                                ? AppColors.warningDarkContainer
                                : AppColors.warningLight)
                          : isOwnAccount
                              ? (isDark
                                    ? AppColors.managerPurpleBackground
                                    : AppColors.managerBackground)
                              : (isDark
                                    ? AppColors.primaryDark
                                    : AppColors.primary),
                      foregroundColor: isFromOwner
                          ? (isDark
                                ? AppColors.warningDark
                                : AppColors.warning)
                          : isOwnAccount
                              ? (isDark
                                    ? AppColors.managerPurpleForeground
                                    : AppColors.managerForeground)
                              : AppColors.white,
                      elevation: 0,
                      side: isFromOwner
                          ? BorderSide(
                              color: isDark
                                  ? AppColors.warningDark
                                  : AppColors.warning,
                              width: 1,
                            )
                          : isOwnAccount
                              ? BorderSide(
                                  color: isDark
                                      ? AppColors.managerPurpleForeground
                                      : AppColors.managerForeground,
                                  width: 1,
                                )
                              : BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
