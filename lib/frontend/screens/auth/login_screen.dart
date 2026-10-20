import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace_emp/backend/api_service.dart';
import 'package:pharmace_emp/frontend/theme/app_colors.dart';
import 'package:pharmace_emp/frontend/theme/app_theme_extension.dart';
import 'package:pharmace_emp/frontend/widgets/text_feild_widget.dart';

import '../../../backend/auth/secure_storage_service.dart';
import '../../provider/database_provider.dart';
import '../../provider/employee_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    required this.onCreateAccount,
    required this.onSignUp,
    required this.onLogin,
  });

  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;
  final VoidCallback onSignUp;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await _apiService.empLogin(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (response.statusCode == 200 && response.data != null) {
        final empReturnModel = response.data!;
        await SecureStorageService.saveToken(empReturnModel.token!);
        final db = ref.read(databaseProvider);
        await ref.read(employeeProvider.notifier).saveEmployee(empReturnModel);
        // await db.employeeDao.saveEmployee(empReturnModel);
        await db.shopDao.saveShop(empReturnModel);
        widget.onLogin();
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Invalid email or password.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Connection failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Password'),
        content: const Text(
          'Please contact your pharmacy manager or owner to reset your account password.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
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
    final textSecondary =
        colors?.textSecondary ??
        (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    final textTertiary =
        colors?.textTertiary ??
        (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary);
    final borderColor =
        colors?.border ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final dangerColor = colors?.danger ?? AppColors.error;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
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

                  const SizedBox(height: 12),

                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Sign in to your staff account',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Form Card
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.04,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email Field
                          TextFieldWidget(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            isRequired: true,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              final emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          // Password Field
                          TextFieldWidget(
                            controller: _passwordController,
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            isRequired: true,
                            obscureText: _obscurePassword,
                            prefixIcon: Icons.lock_outline_rounded,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: textTertiary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _login(),
                          ),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _showForgotPasswordDialog,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          // Error Message
                          if (_errorMessage != null &&
                              _errorMessage!.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: dangerColor,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),

                          // Login Button
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Switch to Invite Code
                  Center(
                    child: TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          widget.onSignUp();
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: 'New team member? ',
                              style: TextStyle(color: textSecondary),
                            ),
                            const TextSpan(
                              text: 'Enter Invite Code',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
