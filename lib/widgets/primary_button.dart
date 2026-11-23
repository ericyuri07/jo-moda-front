import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_text_styles.dart';
import 'pressable_scale.dart';

/// Botão principal (entrar, cadastrar, enviar pedido): preto sólido, afunda
/// ao toque e troca o texto pelo carregamento com um fade.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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

    return Semantics(
      button: true,
      enabled: enabled,
      child: PressableScale(
        onTap: enabled ? onPressed : null,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedOpacity(
      duration: AppDurations.selection,
      opacity: onPressed == null ? AppSizes.disabledOpacity : 1,
      child: Container(
        height: AppSizes.buttonHeight,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: AnimatedSwitcher(
          duration: AppDurations.selection,
          switchInCurve: AppCurves.standard,
          switchOutCurve: AppCurves.standard,
          child: isLoading
              ? const SizedBox(
                  key: ValueKey<String>('loading'),
                  width: AppSizes.spinner,
                  height: AppSizes.spinner,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.borderWidthSelected,
                    color: AppColors.textOnDark,
                  ),
                )
              : Text(
                  label,
                  key: const ValueKey<String>('label'),
                  style: AppTextStyles.button,
                ),
        ),
      ),
    );
  }
}
