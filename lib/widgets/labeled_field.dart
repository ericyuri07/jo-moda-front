import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Campo de formulário da área clara: rótulo acima e campo arredondado,
/// como no carrinho do Figma. Usado também no formulário de produtos.
class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction,
    this.suffix,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          textInputAction: textInputAction,
          maxLines: maxLines,
          style: AppTextStyles.input,
          decoration: InputDecoration(hintText: hintText, suffixIcon: suffix),
        ),
      ],
    );
  }
}
