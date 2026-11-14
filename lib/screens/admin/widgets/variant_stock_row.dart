import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';

/// Uma linha do estoque no formulário de produto: "P · Preto", campo de
/// estoque e botão de remover.
class VariantStockRow extends StatelessWidget {
  const VariantStockRow({
    required this.size,
    required this.color,
    required this.stockController,
    required this.onRemove,
    super.key,
  });

  final String size;
  final String color;
  final TextEditingController stockController;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              AppStrings.variantLabel(size, color),
              style: AppTextStyles.bodyStrong,
            ),
          ),
          SizedBox(
            width: AppSizes.stockFieldWidth,
            child: TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: AppStrings.variantStockLabel,
                isDense: true,
              ),
              validator: Validators.stock,
            ),
          ),
          IconButton(
            tooltip: AppStrings.removeVariantTooltip,
            icon: const Icon(Icons.close, color: AppColors.danger),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
