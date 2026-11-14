import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';

/// Botão redondo de ação das listas do admin: editar (dourado) ou excluir
/// (vermelho).
class AdminActionButton extends StatelessWidget {
  const AdminActionButton.edit({required this.onPressed, super.key})
    : tooltip = AppStrings.editTooltip,
      icon = Icons.edit_outlined,
      color = AppColors.goldDark,
      background = AppColors.goldSoft;

  const AdminActionButton.delete({required this.onPressed, super.key})
    : tooltip = AppStrings.deleteTooltip,
      icon = Icons.delete_outline,
      color = AppColors.danger,
      background = AppColors.accentSoft;

  final String tooltip;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.actionButton,
      height: AppSizes.actionButton,
      child: IconButton.filled(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: background,
          foregroundColor: color,
        ),
        icon: Icon(icon, size: AppSizes.iconSm),
        onPressed: onPressed,
      ),
    );
  }
}
