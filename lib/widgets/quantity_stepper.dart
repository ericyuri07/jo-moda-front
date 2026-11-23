import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Seletor de quantidade: "−  1  +". O número troca com um deslize vertical
/// (sobe ao aumentar, desce ao diminuir).
class QuantityStepper extends StatefulWidget {
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
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  bool _increasing = true;

  @override
  void didUpdateWidget(QuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _increasing = widget.quantity > oldWidget.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int quantity = widget.quantity;
    final double direction = _increasing ? 1 : -1;

    return Container(
      width: widget.compact
          ? AppSizes.stepperWidthCompact
          : AppSizes.stepperWidth,
      height: widget.compact
          ? AppSizes.stepperHeightCompact
          : AppSizes.stepperHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove_rounded,
            onTap: quantity > 1 ? () => widget.onChanged(quantity - 1) : null,
          ),
          ClipRect(
            child: AnimatedSwitcher(
              duration: AppDurations.selection,
              switchInCurve: AppCurves.standard,
              switchOutCurve: AppCurves.standard,
              transitionBuilder: (child, animation) {
                final bool incoming =
                    child.key == ValueKey<int>(widget.quantity);
                final Offset begin = Offset(
                  0,
                  incoming ? direction : -direction,
                );

                return SlideTransition(
                  position: Tween<Offset>(
                    begin: begin,
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                '$quantity',
                key: ValueKey<int>(quantity),
                style: AppTextStyles.title,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            onTap: quantity < widget.maxQuantity
                ? () => widget.onChanged(quantity + 1)
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
          color: onTap == null ? AppColors.hint : AppColors.textPrimary,
        ),
      ),
    );
  }
}
