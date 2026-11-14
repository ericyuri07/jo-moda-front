import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Escolha entre "Entrega" e "Retirada" do carrinho, em pílula segmentada.
class DeliveryToggle extends StatelessWidget {
  const DeliveryToggle({
    required this.isDelivery,
    required this.onChanged,
    super.key,
  });

  final bool isDelivery;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.toggleHeight,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Row(
        children: <Widget>[
          _Option(
            label: AppStrings.delivery,
            icon: Icons.local_shipping_outlined,
            selected: isDelivery,
            onTap: () => onChanged(true),
          ),
          _Option(
            label: AppStrings.pickup,
            icon: Icons.storefront_outlined,
            selected: !isDelivery,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.gold : AppColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.selection,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: AppSizes.iconSm, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.bodyStrong.copyWith(
                  color: selected
                      ? AppColors.textOnDark
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
