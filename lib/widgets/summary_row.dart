import 'package:flutter/material.dart';

import '../core/theme/app_text_styles.dart';

/// Linha do resumo do carrinho (Subtotal, Total) sobre o card escuro.
/// [highlight] deixa o valor grande e dourado (o total).
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
    super.key,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(label, style: AppTextStyles.summaryOnDark),
        Text(
          value,
          style: highlight
              ? AppTextStyles.totalOnDark
              : AppTextStyles.summaryOnDark,
        ),
      ],
    );
  }
}
