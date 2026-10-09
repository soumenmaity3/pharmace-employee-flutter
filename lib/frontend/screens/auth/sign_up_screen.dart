import 'package:flutter/material.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/backend/model/emp_model_invite_id.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';

import '../../widgets/sign_up_widget.dart';
import 'complete_profile_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

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
      final response = await ApiService().getEmpDataByInviteCode(inviteCode: inviteCode);

      if (response.statusCode == 200 && response.data != null) {
        if (!mounted) return;
        _showInviteDetailsSheet(response.data!);
      } else {
        setState(() {
          _errorMessage = response.message ?? "Invalid invite code.";
        });
      }
    } catch (e) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        final theme = Theme.of(ctx);
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                        .withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
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
                          'Invitation Verified',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          'Invite Code: ${emp.inviteId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Employee Info Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(16),
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
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
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
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            emp.empEmail,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Pharmacy & Owner Details Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    if (emp.shopName != null)
                      _buildDetailRow(
                        theme: theme,
                        isDark: isDark,
                        icon: Icons.storefront_outlined,
                        title: 'Pharmacy',
                        value: emp.shopName!,
                      ),
                    if (emp.shopCode != null)
                      _buildDetailRow(
                        theme: theme,
                        isDark: isDark,
                        icon: Icons.confirmation_number_outlined,
                        title: 'Shop Code',
                        value: emp.shopCode!,
                      ),
                    if (emp.ownerName != null)
                      _buildDetailRow(
                        theme: theme,
                        isDark: isDark,
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Owner',
                        value: emp.ownerName!,
                      ),
                    if (emp.shopAddress != null)
                      _buildDetailRow(
                        theme: theme,
                        isDark: isDark,
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        value: emp.shopAddress!,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CompleteProfileScreen(empData: emp),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
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
    required bool isDark,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SignUpWidget(
              isLoading: _isLoading,
              errorMessage: _errorMessage,
              onScanQr: (value) {
                debugPrint('QR Code: $value');
              },
              onVerify: (code) {
                _verifyInviteCode(code);
              },
            ),
          ),
        ),
      ),
    );
  }
}