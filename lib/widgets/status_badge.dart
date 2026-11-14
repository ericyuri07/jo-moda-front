import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Etiqueta colorida pequena ("Destaque", "Inativo").
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(label, style: AppTextStyles.badge),
    );
  }
}
