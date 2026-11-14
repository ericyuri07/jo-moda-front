import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Botão principal das telas de entrada: gradiente dourado + loading.
class GoldButton extends StatelessWidget {
  const GoldButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;

    return Opacity(
      opacity: enabled ? 1 : AppSizes.disabledOpacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[
              AppColors.goldLight,
              AppColors.gold,
              AppColors.goldDark,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: enabled ? onPressed : null,
            child: SizedBox(
              height: AppSizes.goldButtonHeight,
              width: double.infinity,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: AppSizes.spinner,
                        height: AppSizes.spinner,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.borderWidthSelected,
                          color: AppColors.authBackground,
                        ),
                      )
                    : Text(label, style: AppTextStyles.goldButton),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
