import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/backend/model/emp_return_model.dart';
import 'package:pharmace_emp/frontend/provider/shop_provider.dart';
import 'package:pharmace_emp/frontend/screens/fragment/manager/widgets/team/team_member_widget.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

class ManTeamScreen extends ConsumerStatefulWidget {
  const ManTeamScreen({super.key});

  @override
  ConsumerState<ManTeamScreen> createState() => _ManTeamScreenState();
}

class _ManTeamScreenState extends ConsumerState<ManTeamScreen> {
  List<EmpBody> _allEmployees = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllEmployees();
    });
  }

  Future<void> _fetchAllEmployees() async {
    final shopAsync = ref.read(shopProvider);
    final shop = shopAsync.value;
    final shopId = shop?.id;

    if (shopId == null || shopId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Shop details not found.';
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().getAllEmployee(shopId: shopId);

      if (!mounted) return;

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          response.data != null) {
        setState(() {
          _allEmployees = response.data!;
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        final error = response.message ?? 'Failed to load team members.';
        setState(() {
          _isLoading = false;
          _errorMessage = error;
        });
        _showErrorSnackBar(error);
      }
    } catch (e) {
      if (!mounted) return;
      const error = 'Connection error. Please try again.';
      setState(() {
        _isLoading = false;
        _errorMessage = error;
      });
      _showErrorSnackBar(error);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _fetchAllEmployees,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _fetchAllEmployees,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Team',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Duty status for this shop. New invite passes are issued from the owner console, not here.',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isLoading)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: isDark
                                ? AppColors.errorDark
                                : AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _fetchAllEmployees,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else if (_allEmployees.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No team members found',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (final emp in _allEmployees) ...[
                          TeamMemberWidget(
                            name: emp.name,
                            email: emp.email ?? '',
                            role: emp.role ?? 'Staff',
                            isOnDuty: true,
                            isFromOwner: emp.isFromOwner ?? false,
                            onMarkInactive: () {
                              _inactiveBottomSheet(
                                context,
                                theme,
                                employee: emp,
                                onConfirm: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${emp.name} marked as inactive.',
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            onSendMessage: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Messaging feature for ${emp.name}...',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'team_fb',
          onPressed: () {},
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  void _inactiveBottomSheet(
    BuildContext context,
    ThemeData theme, {
    EmpBody? employee,
    VoidCallback? onConfirm,
  }) {
    final isOwner = employee?.isFromOwner == true;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final primaryAccent = isOwner
        ? (isDark ? AppColors.goldDark : AppColors.gold)
        : (isDark ? AppColors.errorDark : AppColors.error);
    final accentBg = isOwner
        ? (isDark ? AppColors.goldDarkContainer : AppColors.goldLight)
        : (isDark ? AppColors.errorDarkContainer : AppColors.errorLight);
    final headerIcon = isOwner
        ? Icons.admin_panel_settings_rounded
        : Icons.person_off_rounded;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                // Drag Handle
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

                // Icon & Title Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        headerIcon,
                        color: primaryAccent,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isOwner
                                ? 'Owner Account'
                                : 'Mark as Inactive',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isOwner
                                ? 'Action Protected'
                                : (employee?.name ?? 'Staff Member'),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Employee Info Card (Preview)
                if (employee != null) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? theme.scaffoldBackgroundColor
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: accentBg,
                          child: Text(
                            employee.name.isNotEmpty
                                ? employee.name[0].toUpperCase()
                                : 'E',
                            style: TextStyle(
                              color: primaryAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (employee.email != null &&
                                  employee.email!.isNotEmpty)
                                Text(
                                  employee.email!,
                                  style: theme.textTheme.bodySmall?.copyWith(
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
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accentBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isOwner) ...[
                                Icon(
                                  Icons.star_rounded,
                                  size: 14,
                                  color: primaryAccent,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                isOwner
                                    ? 'Owner'
                                    : (employee.role ?? 'Staff'),
                                style: TextStyle(
                                  color: primaryAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Description Text & Warning Box
                if (isOwner) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.warningDarkContainer
                          : AppColors.warningLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isDark ? AppColors.warningDark : AppColors.warning,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                          color:
                              isDark ? AppColors.warningDark : AppColors.warning,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Employees cannot perform any actions or mark the Shop Owner as inactive. Owner accounts are fully protected.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'All actions on owner accounts are disabled across employee consoles.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Are you sure you want to mark this employee as inactive? They will no longer have active shift privileges or duty access until reactivated.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Action Buttons
                if (isOwner) ...[
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDark ? AppColors.goldDark : AppColors.gold,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Understood',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: borderColor),
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
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onConfirm?.call();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Yes, Confirm',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
