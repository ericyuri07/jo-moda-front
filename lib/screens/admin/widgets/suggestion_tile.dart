import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/product.dart';
import '../../../widgets/network_image_box.dart';

/// Produto sugerido no formulário: miniatura, nome e botão de remover.
/// Avisa quando está inativo (nesse caso não aparece na loja).
class SuggestionTile extends StatelessWidget {
  const SuggestionTile({
    required this.product,
    required this.onRemove,
    super.key,
  });

  final Product product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: SizedBox(
              width: AppSizes.adminThumb,
              height: AppSizes.adminThumb,
              child: NetworkImageBox(url: product.imageUrl),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body,
                ),
                if (!product.active)
                  const Text(
                    AppStrings.badgeInactive,
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: AppStrings.removeSuggestionTooltip,
            icon: const Icon(Icons.close, color: AppColors.danger),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
