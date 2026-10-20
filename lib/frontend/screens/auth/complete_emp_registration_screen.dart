import 'package:flutter/material.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/backend/model/emp_model_invite_id.dart';
import 'package:pharmace_emp/frontend/screens/auth/login_screen.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';
import 'package:pharmace_emp/frontend/theme/app_theme_extension.dart';

class CompleteEmpRegistrationScreen extends StatefulWidget {
  const CompleteEmpRegistrationScreen({super.key, required this.empData, required this.onLogin});

  final EmpModelInviteId empData;
  final VoidCallback onLogin;

  @override
  State<CompleteEmpRegistrationScreen> createState() =>
      _CompleteEmpRegistrationScreenState();
}

class _CompleteEmpRegistrationScreenState
    extends State<CompleteEmpRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Frontend-only email verification state
  bool _isEmailVerified = false;
  bool _isVerifyingEmail = false;
  bool _showOtpInput = false;
  final TextEditingController _otpController = TextEditingController();
  String? _otpErrorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.empData.empName);
    _emailController = TextEditingController(text: widget.empData.empEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Color _getRoleBg(RoleEmp role) {
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

  Color _getRoleFg(RoleEmp role) {
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

  Future<void> _handleCompleteRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isEmailVerified) {
      setState(() {
        _errorMessage = 'Please verify your email address to continue.';
      });
      return;
    }

    if (!_agreeTerms) {
      setState(() {
        _errorMessage = 'Please accept the terms to proceed.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().completeRegistration(
        role: widget.empData.empRole.value.toString(),
        email: widget.empData.empEmail,
        name: _nameController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        shopId: widget.empData.shopId,
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        setState(() {
          _errorMessage =
              response.message ?? 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Connection failed: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Account Created!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Your profile for ${widget.empData.shopName ?? "pharmacy"} is ready. You can now log in to begin your shift.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  widget.onLogin();// Back to sign up / login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.extension<AppThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Pharmacy Badge Card
                    _buildPharmacyHeaderCard(theme, isDark),

                    const SizedBox(height: 24),

                    // Section Title
                    Text(
                      'Account Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Set up your name and secure password to access your staff dashboard.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Error Message Banner
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (colors?.danger ?? AppColors.error).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colors?.danger ?? AppColors.error,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colors?.danger ?? AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: colors?.danger ?? AppColors.error,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Full Name Field
                    _buildLabel('Full Name', isRequired: true),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(
                        hintText: 'Enter your full name',
                        prefixIcon: Icons.person_outline_rounded,
                        isDark: isDark,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Email Address Field with Verify action at the side
                    _buildLabel('Email Address (Invitation)', isRequired: true),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            readOnly: true,
                            decoration:
                                _inputDecoration(
                                  hintText: 'Email address',
                                  prefixIcon: Icons.email_outlined,
                                  suffixIcon: _isEmailVerified
                                      ? const Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.success,
                                          size: 20,
                                        )
                                      : null,
                                  isDark: isDark,
                                ).copyWith(
                                  fillColor: isDark
                                      ? AppColors.darkSurfaceVariant.withValues(
                                          alpha: 0.5,
                                        )
                                      : AppColors.lightSurfaceVariant
                                            .withValues(alpha: 0.7),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildEmailVerifyButton(isDark),
                      ],
                    ),

                    // Inline OTP Box when verification is opened
                    if (_showOtpInput && !_isEmailVerified) ...[
                      const SizedBox(height: 10),
                      _buildFrontendOtpBox(theme, isDark),
                    ],

                    const SizedBox(height: 16),

                    // Phone Number Field (Optional)
                    _buildLabel('Phone Number', isRequired: false),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        hintText: 'e.g. 9876543210',
                        prefixIcon: Icons.phone_outlined,
                        isDark: isDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    _buildLabel('Create Password', isRequired: true),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration(
                        hintText: 'At least 6 characters',
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        isDark: isDark,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password Field
                    _buildLabel('Confirm Password', isRequired: true),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: _inputDecoration(
                        hintText: 'Re-enter your password',
                        prefixIcon: Icons.lock_reset_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        isDark: isDark,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Terms Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreeTerms,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _agreeTerms = val ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreeTerms = !_agreeTerms;
                              });
                            },
                            child: Text(
                              'I confirm that I am joining ${widget.empData.shopName ?? "this pharmacy"} as ${widget.empData.empRole.value} and agree to terms.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _handleCompleteRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Complete Registration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyHeaderCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_pharmacy_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.empData.shopName ?? 'Assigned Pharmacy',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (widget.empData.shopCode != null)
                      Text(
                        'Code: ${widget.empData.shopCode}',
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _getRoleBg(widget.empData.empRole),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.empData.empRole.value,
                  style: TextStyle(
                    color: _getRoleFg(widget.empData.empRole),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (widget.empData.ownerName != null ||
              widget.empData.shopAddress != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            if (widget.empData.ownerName != null)
              _buildSmallInfo(
                icon: Icons.person_pin_outlined,
                label: 'Owner: ${widget.empData.ownerName}',
                isDark: isDark,
              ),
            if (widget.empData.shopAddress != null)
              _buildSmallInfo(
                icon: Icons.location_on_outlined,
                label: widget.empData.shopAddress!,
                isDark: isDark,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSmallInfo({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }

  Widget _buildEmailVerifyButton(bool isDark) {
    if (_isEmailVerified) {
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.successDarkContainer
              : AppColors.successLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
            SizedBox(width: 6),
            Text(
              'Verified',
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isVerifyingEmail
            ? null
            : () {
                setState(() {
                  _showOtpInput = !_showOtpInput;
                  _otpErrorMessage = null;
                });
              },
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isVerifyingEmail
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _showOtpInput ? 'Cancel' : 'Verify',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildFrontendOtpBox(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Enter verification code sent to your email',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _otpController.text = '1234';
                },
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    'Demo: 1234',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration:
                      _inputDecoration(
                        hintText: 'Enter code (e.g. 1234)',
                        prefixIcon: Icons.pin_outlined,
                        isDark: isDark,
                      ).copyWith(
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: _handleFrontendVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          if (_otpErrorMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              _otpErrorMessage!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleFrontendVerifyOtp() async {
    final code = _otpController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _otpErrorMessage = 'Please enter verification code';
      });
      return;
    }

    setState(() {
      _isVerifyingEmail = true;
      _otpErrorMessage = null;
    });

    // Simulated short frontend check
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isVerifyingEmail = false;
      _isEmailVerified = true;
      _showOtpInput = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email verified successfully!'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
