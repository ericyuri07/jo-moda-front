import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Campo das telas de entrada: escuro, com ícone dourado à esquerda e borda
/// dourada ao focar (sem rótulo acima, só o `hintText`).
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.hintText,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
    super.key,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTextStyles.inputOnDark,
      cursorColor: AppColors.gold,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.inputHint,
        prefixIcon: Icon(icon, color: AppColors.gold, size: AppSizes.iconSm),
        suffixIcon: suffixIcon,
        suffixIconColor: AppColors.textOnDarkMuted,
        filled: true,
        fillColor: AppColors.authField,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        border: _border(AppColors.transparent),
        enabledBorder: _border(AppColors.transparent),
        focusedBorder: _border(
          AppColors.gold,
          width: AppSizes.borderWidthFocus,
        ),
        errorBorder: _border(AppColors.errorOnDark),
        focusedErrorBorder: _border(
          AppColors.errorOnDark,
          width: AppSizes.borderWidthFocus,
        ),
        errorStyle: AppTextStyles.errorOnDark,
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(
        color: color,
        width: width ?? AppSizes.borderWidth,
      ),
    );
  }
}
