import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/network_image_box.dart';

/// Foto extra no formulário de produto: miniatura, endereço e botão de remover.
class ExtraImageTile extends StatelessWidget {
  const ExtraImageTile({required this.url, required this.onRemove, super.key});

  final String url;
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
              child: NetworkImageBox(url: url),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              url,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ),
          IconButton(
            tooltip: AppStrings.removeImageTooltip,
            icon: const Icon(Icons.close, color: AppColors.danger),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
