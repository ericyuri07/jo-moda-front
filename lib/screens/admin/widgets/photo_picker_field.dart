import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/network_image_box.dart';

/// Campo de foto do admin (produto e categoria): prévia, "Escolher/Trocar foto" e
/// "Remover". Durante o upload mostra um indicador e bloqueia os botões.
class PhotoPickerField extends StatelessWidget {
  const PhotoPickerField({
    required this.url,
    required this.isUploading,
    required this.onPick,
    required this.onRemove,
    super.key,
  });

  final String? url;
  final bool isUploading;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final String? photo = url;
    final bool hasPhoto = photo != null && photo.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            width: AppSizes.photoPreviewWidth,
            height: AppSizes.photoPreviewHeight,
            color: AppColors.placeholder,
            child: isUploading
                ? const Center(child: CircularProgressIndicator())
                : hasPhoto
                ? NetworkImageBox(url: photo)
                : const Icon(
                    Icons.add_a_photo_outlined,
                    size: AppSizes.iconXl,
                    color: AppColors.hint,
                  ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Com foto, o título do card já basta; o aviso só aparece sem
              // foto ou durante o envio.
              if (isUploading || !hasPhoto) ...<Widget>[
                Text(
                  isUploading
                      ? AppStrings.photoUploading
                      : AppStrings.noMainPhoto,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              OutlinedButton.icon(
                onPressed: isUploading ? null : onPick,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  hasPhoto ? AppStrings.changePhoto : AppStrings.choosePhoto,
                ),
              ),
              if (hasPhoto && !isUploading)
                TextButton.icon(
                  onPressed: onRemove,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.danger,
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text(AppStrings.removePhoto),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
