import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmace_emp/frontend/screens/auth/login_screen.dart';

import '../screens/auth/qr_scanner_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_extension.dart';
import 'text_feild_widget.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    this.controller,
    this.onVerify,
    this.onScanQr,
    this.isLoading = false,
    this.errorMessage,
    required this.onSignIn,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onVerify;
  final ValueChanged<String>? onScanQr;
  final bool isLoading;
  final String? errorMessage;

  // final VoidCallback onSignup;
  final VoidCallback onSignIn;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late final TextEditingController _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _effectiveController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant SignUpWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController).removeListener(
        _onTextChanged,
      );
      _effectiveController.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onTextChanged);
    _internalController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  Future<void> _openQrScanner() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'QR scanner is available on mobile devices only.',
          ),
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (!mounted) return;

    if (result != null && result.trim().isNotEmpty) {
      final cleanResult = result.trim();
      _effectiveController.text = cleanResult;
      _effectiveController.selection = TextSelection.fromPosition(
        TextPosition(offset: cleanResult.length),
      );
      widget.onScanQr?.call(cleanResult);
    }
  }

  void _handleVerify() {
    final code = _effectiveController.text.trim();
    if (code.isNotEmpty && !widget.isLoading) {
      widget.onVerify?.call(code);
    }
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

    final hasInput = _effectiveController.text.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            'Join Team',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Scan QR code or enter your staff invite code.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          // QR Scanner Card
          InkWell(
            onTap: widget.isLoading ? null : _openQrScanner,
            borderRadius: BorderRadius.circular(14),
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: AppColors.primary.withValues(alpha: isDark ? 0.5 : 0.6),
                strokeWidth: 1.2,
                dashPattern: const [6, 4],
                radius: const Radius.circular(14),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant.withValues(alpha: 0.3)
                      : AppColors.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 26,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Scan Invite QR',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Simple Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(child: Divider(color: borderColor, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'or',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: borderColor, thickness: 1)),
              ],
            ),
          ),

          // Code Input
          TextFieldWidget(
            controller: _effectiveController,
            labelText: 'Invite Code',
            hintText: 'e.g. PHM-4821',
            isRequired: true,
            prefixIcon: Icons.pin_outlined,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]')),
            ],
            suffixIcon: hasInput
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      size: 18,
                      color: textTertiary,
                    ),
                    onPressed: () => _effectiveController.clear(),
                  )
                : null,
            onFieldSubmitted: (_) => _handleVerify(),
          ),

          // Error Message
          if (widget.errorMessage != null &&
              widget.errorMessage!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              widget.errorMessage!,
              style: TextStyle(
                color: dangerColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Verify Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: (hasInput && !widget.isLoading) ? _handleVerify : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : const Color(0xFFD4E2DC),
                disabledForegroundColor: isDark
                    ? AppColors.darkTextTertiary
                    : const Color(0xFF88A096),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Verify Code',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 14),

          // Direct Link to Login
          Center(
            child: TextButton(
              onPressed: () {
                widget.onSignIn();
              },
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: textSecondary),
                    ),
                    const TextSpan(
                      text: 'Log In',
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
    );
  }
}
