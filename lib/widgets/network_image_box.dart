import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_sizes.dart';

/// Imagem da internet que aparece com fade depois de baixada, com
/// placeholder enquanto carrega e quando falha (a tela nunca quebra).
class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    required this.url,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final String? address = url;
    if (address == null || address.isEmpty) return const _Placeholder();

    return Image.network(
      address,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const ColoredBox(color: AppColors.placeholder),
            AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: AppDurations.imageFade,
              curve: AppCurves.standard,
              child: child,
            ),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) => const _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.placeholder,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.hint,
          size: AppSizes.iconMd,
        ),
      ),
    );
  }
}
