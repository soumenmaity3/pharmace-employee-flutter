import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/frontend/provider/employee_provider.dart';
import 'package:pharmace_emp/frontend/provider/shop_provider.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/activity_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/billing_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/refund_list_screen.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/screens/task_list_screen.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingText;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingText,
    this.onTap,
  });
}

class ManMoreScreen extends ConsumerWidget {
  const ManMoreScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final employee = ref.watch(employeeProvider).value;
    final shop = ref.watch(shopProvider).value;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Text(
                'More & Settings',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manager controls, shop configurations, and account options.',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // Manager Profile Header Card
              _buildProfileHeaderCard(context, theme, isDark, employee, shop),

              const SizedBox(height: 20),

              // Operations Section
              _buildSectionTitle(context, 'Manager Operations'),
              const SizedBox(height: 8),
              _buildMenuCard(
                context: context,
                isDark: isDark,
                items: [
                  _MenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Billing & POS',
                    subtitle: 'Create new bill and checkout',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BillingScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.refresh_rounded,
                    title: 'Refund Approvals',
                    subtitle: 'Review customer return claims',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RefundListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.task_alt_rounded,
                    title: 'Task Management',
                    subtitle: 'Shift assignments and duties',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuItem(
                    icon: Icons.local_activity_outlined,
                    title: 'Activity Logs',
                    subtitle: 'Audit trail of system events',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActivityScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Shop Details Section
              _buildSectionTitle(context, 'Shop & Application'),
              const SizedBox(height: 8),
              _buildMenuCard(
                context: context,
                isDark: isDark,
                items: [
                  _MenuItem(
                    icon: Icons.storefront_outlined,
                    title: 'Shop Information',
                    subtitle: shop?.shopName ?? 'Pharmacy Store',
                    trailingText: shop?.shopCode ?? 'CODE',
                    onTap: () =>
                        _showShopDetailsBottomSheet(context, shop, isDark),
                  ),
                  _MenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'App Version',
                    subtitle: 'Pharmase Employee v1.0.0',
                    trailingText: 'v1.0.0',
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutConfirmation(context),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'Logout Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      color: isDark ? AppColors.errorDark : AppColors.error,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    dynamic employee,
    dynamic shop,
  ) {
    final name = employee?.name ?? 'Manager';
    final email = employee?.email ?? 'manager@pharmacy.com';
    final role = employee?.role ?? 'Manager';
    final shopName = shop?.shopName ?? 'Pharmacy Store';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isDark
                ? AppColors.managerPurpleBackground
                : AppColors.managerBackground,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'M',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.managerPurpleForeground
                    : AppColors.managerForeground,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.managerPurpleBackground
                            : AppColors.managerBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.managerPurpleForeground
                              : AppColors.managerForeground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.storefront,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      shopName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.textTheme.labelMedium?.color,
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required bool isDark,
    required List<_MenuItem> items,
  }) {
    final theme = Theme.of(context);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              ListTile(
                onTap: items[i].onTap,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    items[i].icon,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                title: Text(
                  items[i].title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  items[i].subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                trailing: items[i].trailingText != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.lightSurfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          items[i].trailingText!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.chevron_right_rounded,
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
              ),
              if (i < items.length - 1)
                Divider(height: 1, indent: 56, color: borderColor),
            ],
          ],
        ),
      ),
    );
  }

  void _showShopDetailsBottomSheet(
    BuildContext context,
    dynamic shop,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Shop Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                _buildShopDetailRow(
                  context,
                  'Shop Name',
                  shop?.shopName ?? 'N/A',
                ),
                _buildShopDetailRow(
                  context,
                  'Shop Code',
                  shop?.shopCode ?? 'N/A',
                ),
                _buildShopDetailRow(
                  context,
                  'License Number',
                  shop?.licenseNumber ?? 'N/A',
                ),
                _buildShopDetailRow(context, 'Address', shop?.address ?? 'N/A'),
                _buildShopDetailRow(context, 'Phone', shop?.phone ?? 'N/A'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShopDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

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
                'Are you sure you want to log out?\nYou will need to sign in again to access your account.',
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
                        onLogout();
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
}
