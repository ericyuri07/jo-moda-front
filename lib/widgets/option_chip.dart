import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Pílula de opção de cor ou tamanho, do tamanho do texto.
/// Selecionada = preta com texto branco; indisponível = riscada e sem toque.
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
        : AppColors.placeholder;

    final TextStyle style = selected
        ? AppTextStyles.chip.copyWith(color: AppColors.textOnDark)
        : available
        ? AppTextStyles.chip
        : AppTextStyles.chip.copyWith(
            color: AppColors.hint,
            decoration: TextDecoration.lineThrough,
          );

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: available ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: AppDurations.selection,
          constraints: const BoxConstraints(
            minWidth: AppSizes.optionChipMinWidth,
            minHeight: AppSizes.optionChipHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: AppSizes.borderWidth,
            ),
          ),
          child: Center(widthFactor: 1, child: Text(label, style: style)),
        ),
      ),
    );
  }
}
