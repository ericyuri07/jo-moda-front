import 'package:flutter/material.dart';

import '../core/constants/app_assets.dart';

/// Logo JM / JÔ MODAS (`assets/images/logo.png`) em um quadrado de [size].
class JoLogo extends StatelessWidget {
  const JoLogo({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
