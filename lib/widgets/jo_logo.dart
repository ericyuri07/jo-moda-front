import 'package:flutter/material.dart';

import '../core/constants/app_assets.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Logo JM / JÔ MODAS. Usa `assets/images/logo.png`; enquanto o arquivo não
/// existir, mostra uma versão em texto dourado.
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
      errorBuilder: (context, error, stackTrace) => _TextLogo(size: size),
    );
  }
}

class _TextLogo extends StatelessWidget {
  const _TextLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              AppColors.goldLight,
              AppColors.gold,
              AppColors.goldDark,
            ],
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(AppStrings.logoMonogram, style: AppTextStyles.logoMonogram),
              Text(AppStrings.logoName, style: AppTextStyles.logoName),
            ],
          ),
        ),
      ),
    );
  }
}
