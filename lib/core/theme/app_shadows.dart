import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

/// Sombras padrão. A interface usa bordas finas; sombra só em elementos que
/// flutuam sobre o conteúdo (barra fixa do formulário).
abstract final class AppShadows {
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadowSoft,
      blurRadius: AppSizes.shadowBlur,
      offset: Offset(0, -AppSizes.shadowOffsetY),
    ),
  ];
}
