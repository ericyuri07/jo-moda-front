import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Título de seção da marca: texto em serifa com um traço dourado embaixo e,
/// opcionalmente, um texto auxiliar à direita ("12 peças").
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final String? info = trailing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: AppTextStyles.sectionHeading),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: AppSizes.sectionBarWidth,
                height: AppSizes.sectionBarHeight,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ],
          ),
        ),
        if (info != null) Text(info, style: AppTextStyles.caption),
      ],
    );
  }
}
