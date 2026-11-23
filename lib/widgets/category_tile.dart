import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'network_image_box.dart';
import 'pressable_scale.dart';

/// Categoria da Home em círculo; a selecionada cresce um pouco e ganha um
/// anel preto. Tocar filtra a vitrine.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.name,
    required this.imageUrl,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.categoryWidth,
        child: Column(
          children: <Widget>[
            AnimatedScale(
              scale: selected ? AppSizes.selectedScale : 1,
              duration: AppDurations.selection,
              curve: AppCurves.standard,
              child: AnimatedContainer(
                duration: AppDurations.selection,
                curve: AppCurves.standard,
                width: AppSizes.categoryAvatar,
                height: AppSizes.categoryAvatar,
                padding: const EdgeInsets.all(AppSpacing.hairline),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: AppSizes.borderWidthSelected,
                  ),
                ),
                child: ClipOval(
                  child: (imageUrl ?? '').isEmpty
                      ? _Initial(name)
                      : NetworkImageBox(url: imageUrl),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedDefaultTextStyle(
              duration: AppDurations.selection,
              style: selected ? AppTextStyles.chip : AppTextStyles.caption,
              child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

/// Categoria ainda sem produto (sem foto): inicial sobre fundo neutro.
class _Initial extends StatelessWidget {
  const _Initial(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Text(
          name.isEmpty ? '' : name.substring(0, 1).toUpperCase(),
          style: AppTextStyles.sectionHeading.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
