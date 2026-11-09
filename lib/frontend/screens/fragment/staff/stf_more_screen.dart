import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';
import 'package:pharmace_emp/frontend/provider/app_view_provider.dart';
import 'package:pharmace_emp/frontend/provider/employee_provider.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class StfMoreScreen extends ConsumerWidget {
  const StfMoreScreen({super.key, this.onLogout});

  final VoidCallback? onLogout;

  void _showLogoutConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
          actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.errorDark : AppColors.error)
                      .withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 32,
                  color: isDark ? AppColors.errorDark : AppColors.error,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Logout Account?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to log out of your account?\nYou will need to sign in again to access the portal.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        onLogout?.call();
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.errorDark
                            : AppColors.error,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showShiftLogoutConfirmation(
    BuildContext context,
    WidgetRef ref,
    EmpBody? employee,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isShiftLoggedOut = employee?.isLogOut ?? false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
          actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: (isShiftLoggedOut
                          ? AppColors.primary
                          : (isDark ? AppColors.warningDark : AppColors.warning))
                      .withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isShiftLoggedOut
                      ? Icons.play_arrow_rounded
                      : Icons.punch_clock_rounded,
                  size: 32,
                  color: isShiftLoggedOut
                      ? AppColors.primary
                      : (isDark ? AppColors.warningDark : AppColors.warning),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isShiftLoggedOut ? 'Resume Today\'s Shift?' : 'End Today\'s Shift?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isShiftLoggedOut
                    ? 'Are you sure you want to resume your shift for today?\nYour active working session will be restored.'
                    : 'Are you sure you want to end your shift for today?\nYour daily working session will be closed.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(dialogContext);

                        if (!isShiftLoggedOut) {
                          try {
                            await ApiService().logOutEmployee();
                          } catch (_) {}
                          await ref
                              .read(employeeProvider.notifier)
                              .setShiftLogoutStatus(true);
                          ref.read(selectedNavIndexProvider.notifier).state = 0;
                        } else {
                          await ref
                              .read(employeeProvider.notifier)
                              .setShiftLogoutStatus(false);
                          ref.read(selectedNavIndexProvider.notifier).state = 0;
                        }
                      },
                      icon: Icon(
                        isShiftLoggedOut
                            ? Icons.play_arrow_rounded
                            : Icons.punch_clock_rounded,
                        size: 18,
                      ),
                      label: Text(isShiftLoggedOut ? 'Resume' : 'End Shift'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isShiftLoggedOut
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.warningDark
                                : AppColors.warning),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final employee = ref.watch(employeeProvider).value;
    final isShiftLoggedOut = employee?.isLogOut ?? false;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Staff Options',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              // Today Shift Logout / Resume Card
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showShiftLogoutConfirmation(context, ref, employee),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isShiftLoggedOut
                          ? (isDark
                              ? AppColors.primaryContainer.withValues(alpha: 0.3)
                              : AppColors.primaryContainer)
                          : (isDark
                              ? AppColors.warningDarkContainer.withValues(alpha: 0.6)
                              : AppColors.warningLight),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isShiftLoggedOut
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : (isDark
                                ? AppColors.warningDark.withValues(alpha: 0.4)
                                : AppColors.warning.withValues(alpha: 0.4)),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isShiftLoggedOut
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : (isDark
                                    ? AppColors.warningDark.withValues(alpha: 0.2)
                                    : AppColors.warning.withValues(alpha: 0.15)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isShiftLoggedOut
                                ? Icons.play_arrow_rounded
                                : Icons.punch_clock_rounded,
                            size: 22,
                            color: isShiftLoggedOut
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.warningDark
                                    : AppColors.warning),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isShiftLoggedOut
                                    ? 'Resume Today\'s Shift'
                                    : 'Today Shift Logout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isShiftLoggedOut
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.warningDark
                                          : AppColors.warning),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isShiftLoggedOut
                                    ? 'Clock in & resume your work session'
                                    : 'Clock out & conclude today\'s work session',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: isShiftLoggedOut
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.warningDark
                                  : AppColors.warning),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (onLogout != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutConfirmation(context),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text(
                      'Logout Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.errorDarkContainer
                          : AppColors.errorLight,
                      foregroundColor: isDark
                          ? AppColors.errorDark
                          : AppColors.error,
                      elevation: 0,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.errorDark
                            : AppColors.error,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
