import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'network_image_box.dart';

/// Categoria da Home em círculo; a selecionada ganha anel dourado.
/// Tocar filtra a vitrine.
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
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSizes.categoryWidth,
        child: Column(
          children: <Widget>[
            AnimatedContainer(
              duration: AppDurations.selection,
              width: AppSizes.categoryAvatar,
              height: AppSizes.categoryAvatar,
              padding: const EdgeInsets.all(AppSpacing.hairline),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                boxShadow: AppShadows.card,
                border: Border.all(
                  color: selected ? AppColors.gold : AppColors.surface,
                  width: AppSizes.borderWidthSelected,
                ),
              ),
              child: ClipOval(
                child: (imageUrl ?? '').isEmpty
                    ? _Initial(name)
                    : NetworkImageBox(url: imageUrl),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: selected
                  ? AppTextStyles.chip.copyWith(color: AppColors.goldDark)
                  : AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Categoria ainda sem produto (sem foto): inicial dourada sobre o escuro.
class _Initial extends StatelessWidget {
  const _Initial(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.authBackground,
      child: Center(
        child: Text(
          name.isEmpty ? '' : name.substring(0, 1).toUpperCase(),
          style: AppTextStyles.sectionHeading.copyWith(color: AppColors.gold),
        ),
      ),
    );
  }
}
