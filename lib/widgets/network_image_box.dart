import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';

/// Imagem da internet com placeholder de carregamento e de erro, para a tela
/// nunca quebrar quando uma foto falha.
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
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _Placeholder(),
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
          size: AppSizes.iconXl,
        ),
      ),
    );
  }
}
