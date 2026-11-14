import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';

/// Contador do topo do painel de produtos ("14 Produtos", "3 Destaques").
class AdminStatTile extends StatelessWidget {
  const AdminStatTile({required this.value, required this.label, super.key});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: <Widget>[
          Text('$value', style: AppTextStyles.statValue),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
