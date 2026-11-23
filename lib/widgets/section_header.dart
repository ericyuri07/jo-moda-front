import 'package:flutter/material.dart';

import '../core/theme/app_text_styles.dart';

/// Título de seção: texto à esquerda e, opcionalmente, um texto auxiliar à
/// direita ("12 peças").
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final String? info = trailing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Expanded(child: Text(title, style: AppTextStyles.sectionHeading)),
        if (info != null) Text(info, style: AppTextStyles.caption),
      ],
    );
  }
}
