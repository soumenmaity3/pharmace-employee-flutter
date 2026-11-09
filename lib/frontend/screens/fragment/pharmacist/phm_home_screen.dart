import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/frontend/provider/app_view_provider.dart';
import 'package:pharmace_emp/frontend/provider/employee_provider.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../common/widgets/employee_header_widget.dart';

class PhmHomeScreen extends ConsumerWidget {
  const PhmHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = ref.watch(employeeProvider).value;
    if (employee?.isLogOut ?? true) {
      return _buildLoggedOutState(context, ref);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            SizedBox(height: 16),
            EmployeeHeaderWidget(),
          ],
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
