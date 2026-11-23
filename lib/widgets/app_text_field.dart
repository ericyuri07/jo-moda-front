import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_text_styles.dart';

/// Campo das telas de entrada: preenchido em cinza claro, ícone discreto à
/// esquerda e contorno preto ao focar (sem rótulo acima, só o `hintText`).
/// O visual vem do `inputDecorationTheme` do tema.
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
      style: AppTextStyles.input,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, size: AppSizes.iconSm),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
