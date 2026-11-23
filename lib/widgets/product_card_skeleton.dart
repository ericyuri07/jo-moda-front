import 'package:flutter/material.dart';

import '../core/theme/app_radius.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import 'skeleton.dart';

/// Esqueleto do `ProductCard` (foto, nome e preço) para a vitrine
/// carregando.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Skeleton(radius: AppRadius.lg)),
        SizedBox(height: AppSpacing.md),
        Skeleton(
          width: AppSizes.skeletonLineLong,
          height: AppSizes.skeletonLine,
        ),
        SizedBox(height: AppSpacing.sm),
        Skeleton(
          width: AppSizes.skeletonLineShort,
          height: AppSizes.skeletonLine,
        ),
        SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
