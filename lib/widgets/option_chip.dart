import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'pressable_scale.dart';

/// Opção de cor ou tamanho, do tamanho do texto.
/// Selecionada = preta com texto branco (troca animada); indisponível =
/// riscada e sem toque.
class OptionChip extends StatelessWidget {
  const OptionChip({
    required this.label,
    required this.selected,
    required this.available,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final bool available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = selected
        ? AppColors.primary
        : available
        ? AppColors.surface
        : AppColors.surfaceMuted;

    final TextStyle style = selected
        ? AppTextStyles.chip.copyWith(color: AppColors.textOnDark)
        : available
        ? AppTextStyles.chip
        : AppTextStyles.chip.copyWith(
            color: AppColors.hint,
            decoration: TextDecoration.lineThrough,
            decorationColor: AppColors.hint,
          );

    return Semantics(
      button: true,
      selected: selected,
      enabled: available,
      child: PressableScale(
        onTap: available ? onTap : null,
        child: AnimatedContainer(
          duration: AppDurations.selection,
          curve: AppCurves.standard,
          constraints: const BoxConstraints(
            minWidth: AppSizes.optionChipMinWidth,
            minHeight: AppSizes.optionChipHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: AppSizes.borderWidth,
            ),
          ),
          child: Center(
            widthFactor: 1,
            child: AnimatedDefaultTextStyle(
              duration: AppDurations.selection,
              style: style,
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
