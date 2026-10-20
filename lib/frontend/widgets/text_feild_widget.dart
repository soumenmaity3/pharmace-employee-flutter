import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme_extension.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.isRequired = false,
    this.keyboardType,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.inputFormatters,
    this.autovalidateMode,
    this.helperText,
    this.errorText,
  });

  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool isRequired;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final String? helperText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = theme.extension<AppThemeExtension>();

    final textPrimary = colors?.textPrimary ??
        (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
    final textSecondary = colors?.textSecondary ??
        (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    final textTertiary = colors?.textTertiary ??
        (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary);
    final borderColor = colors?.border ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final errorColor = colors?.danger ?? AppColors.error;

    final field = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      textCapitalization: textCapitalization,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 14.5,
      ),
      validator: validator ??
          (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return '$hintText is required';
            }
            return null;
          },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: textTertiary,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        helperText: helperText,
        helperStyle: theme.textTheme.bodySmall?.copyWith(
          color: textTertiary,
          fontSize: 11.5,
        ),
        errorText: errorText,
        errorMaxLines: 2,
        prefixIcon: prefixWidget ??
            (prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(
                      prefixIcon,
                      color: textTertiary,
                      size: 20,
                    ),
                  )
                : null),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 46,
          minHeight: 46,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 6),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: errorColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: errorColor,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: borderColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );

    if (labelText != null && labelText!.trim().isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                labelText!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (isRequired)
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    '*',
                    style: TextStyle(
                      color: errorColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          field,
        ],
      );
    }

    return field;
  }
}