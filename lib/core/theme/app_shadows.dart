import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

/// Sombras padrão. Use estas listas em `BoxDecoration.boxShadow`.
abstract final class AppShadows {
  /// Cards da loja: sombra baixa e difusa.
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowSoft,
      blurRadius: AppSizes.shadowBlur,
      offset: Offset(0, AppSizes.shadowOffsetY),
    ),
  ];

  /// Elementos sobre fundo escuro (card de entrada, banner).
  static const List<BoxShadow> raised = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: AppSizes.shadowBlur,
      offset: Offset(0, AppSizes.shadowOffsetY),
    ),
  ];
}
