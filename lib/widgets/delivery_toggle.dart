import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Escolha entre "Entrega" e "Retirada" do carrinho: controle segmentado
/// com um indicador preto que desliza até a opção escolhida.
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
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedAlign(
            alignment: isDelivery
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: AppDurations.switcher,
            curve: AppCurves.emphasized,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),
          ),
          Row(
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
    final Color color = selected
        ? AppColors.textOnDark
        : AppColors.textSecondary;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: color),
            duration: AppDurations.switcher,
            curve: AppCurves.standard,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: AppSizes.iconSm, color: value),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: AppTextStyles.bodyStrong.copyWith(color: value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
