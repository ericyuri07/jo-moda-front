import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Seletor de quantidade em pílula: "−  1  +".
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
    this.compact = false,
    super.key,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? AppSizes.stepperWidthCompact : AppSizes.stepperWidth,
      height: compact ? AppSizes.stepperHeightCompact : AppSizes.stepperHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Text('$quantity', style: AppTextStyles.title),
          _StepButton(
            icon: Icons.add,
            onTap: quantity < maxQuantity
                ? () => onChanged(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: AppSizes.iconMd,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          icon,
          size: AppSizes.iconSm,
          color: onTap == null ? AppColors.hint : AppColors.goldDark,
        ),
      ),
    );
  }
}
