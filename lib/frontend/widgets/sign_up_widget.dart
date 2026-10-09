import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/auth/qr_scanner_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_extension.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    this.controller,
    this.onVerify,
    this.onScanQr,
    this.demoCode = 'PHM-4821',
    this.isLoading = false,
    this.errorMessage,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onVerify;

  // Changed from VoidCallback to ValueChanged<String>
  final ValueChanged<String>? onScanQr;

  final String demoCode;
  final bool isLoading;
  final String? errorMessage;

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
    // Check platform safely across Web and native desktop
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR scanning is not available on desktop or web devices.'),
        ),
      );
      return;
    }

    // Open modern animated scanner
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const QrScannerScreen(),
      ),
    );

    if (!mounted) return;

    // If a QR code was scanned
    if (result != null && result.isNotEmpty) {
      // Put scanned value into text field
      _effectiveController.text = result;

      _effectiveController.selection = TextSelection.fromPosition(
        TextPosition(offset: result.length),
      );

      // Notify parent
      widget.onScanQr?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppThemeExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasInput = _effectiveController.text.isNotEmpty;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _openQrScanner,
            borderRadius: BorderRadius.circular(16),
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: AppColors.primaryDark.withValues(alpha: 0.75),
                strokeWidth: 1.2,
                dashPattern: const [6, 4],
                radius: const Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_2_rounded,
                      size: 42,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Scan QR code',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Point your camera at the invitation',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: Text(
                'or enter code',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          TextFormField(
            controller: _effectiveController,
            textCapitalization: TextCapitalization.characters,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. PHM-4821',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder.withValues(alpha: 0.8),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder.withValues(alpha: 0.8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.errorMessage!,
                style: TextStyle(
                  color: colors?.danger ?? AppColors.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: (hasInput && !widget.isLoading)
                  ? () {
                      widget.onVerify?.call(_effectiveController.text.trim());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasInput
                    ? AppColors.primary
                    : const Color(0xFF7FA99B),

                disabledBackgroundColor: const Color(0xFF7FA99B),

                foregroundColor: hasInput
                    ? AppColors.white
                    : const Color(0xFFAEC4BC),

                disabledForegroundColor: const Color(0xFFAEC4BC),

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
                      'Verify code',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'Demo code: ${widget.demoCode}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
