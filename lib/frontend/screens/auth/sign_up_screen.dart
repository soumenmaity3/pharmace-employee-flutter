import 'package:flutter/material.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/backend/model/emp_model_invite_id.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';
import 'package:pharmace_emp/frontend/theme/app_theme_extension.dart';

import '../../widgets/sign_up_widget.dart';
import 'complete_emp_registration_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyInviteCode(String inviteCode) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().getEmpDataByInviteCode(
        inviteCode: inviteCode,
      );

      if (!mounted) return;

      if (response.statusCode == 200 && response.data != null) {
        _showInviteDetailsSheet(response.data!);
      } else {
        setState(() {
          _errorMessage = response.message ?? "Invalid invite code.";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Connection failed. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showInviteDetailsSheet(EmpModelInviteId emp) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.extension<AppThemeExtension>();

    final textPrimary =
        colors?.textPrimary ??
        (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    final textSecondary =
        colors?.textSecondary ??
        (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    final textTertiary =
        colors?.textTertiary ??
        (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary);
    final borderColor =
        colors?.border ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    Color getRoleBg(RoleEmp role) {
      switch (role) {
        case RoleEmp.manager:
          return AppColors.managerBackground;
        case RoleEmp.pharmacist:
          return AppColors.pharmacistBackground;
        case RoleEmp.cashier:
          return AppColors.cashierBackground;
        case RoleEmp.staff:
          return AppColors.staffBackground;
      }
    }

    Color getRoleFg(RoleEmp role) {
      switch (role) {
        case RoleEmp.manager:
          return AppColors.managerForeground;
        case RoleEmp.pharmacist:
          return AppColors.pharmacistForeground;
        case RoleEmp.cashier:
          return AppColors.cashierForeground;
        case RoleEmp.staff:
          return AppColors.staffForeground;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite Verified',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          'Code: ${emp.inviteId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Employee Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          emp.empName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getRoleBg(emp.empRole),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            emp.empRole.value,
                            style: TextStyle(
                              color: getRoleFg(emp.empRole),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 15,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            emp.empEmail,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Pharmacy Details
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    if (emp.shopName != null)
                      _buildDetailRow(
                        theme: theme,
                        icon: Icons.storefront_outlined,
                        title: 'Pharmacy',
                        value: emp.shopName!,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        textTertiary: textTertiary,
                      ),
                    if (emp.shopCode != null)
                      _buildDetailRow(
                        theme: theme,
                        icon: Icons.pin_outlined,
                        title: 'Shop Code',
                        value: emp.shopCode!,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        textTertiary: textTertiary,
                      ),
                    if (emp.ownerName != null)
                      _buildDetailRow(
                        theme: theme,
                        icon: Icons.person_outline,
                        title: 'Owner',
                        value: emp.ownerName!,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        textTertiary: textTertiary,
                      ),
                    if (emp.shopAddress != null)
                      _buildDetailRow(
                        theme: theme,
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        value: emp.shopAddress!,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        textTertiary: textTertiary,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompleteEmpRegistrationScreen(
                          empData: emp,
                          onLogin: widget.onSignIn,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue Registration',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String value,
    required Color textPrimary,
    required Color textSecondary,
    required Color textTertiary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: textTertiary),
          const SizedBox(width: 8),
          Text(
            '$title: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.extension<AppThemeExtension>();

    final textPrimary =
        colors?.textPrimary ??
        (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Brand Logo & Title
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.local_pharmacy_rounded,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'PharmaCE',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: textPrimary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SignUpWidget
                  SignUpWidget(
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    onScanQr: (value) => _verifyInviteCode(value),
                    onVerify: (code) => _verifyInviteCode(code),
                    onSignIn: () {
                      widget.onSignIn();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
