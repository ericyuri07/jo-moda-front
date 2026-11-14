import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import 'network_image_box.dart';
import 'price_block.dart';

/// Card de produto da Home e do "Veja também": foto grande com selo de
/// desconto, nome e preço.
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onTap, super.key});

  final Product product;
  final VoidCallback onTap;

  /// Desconto arredondado ("-30%"), só quando há promoção.
  int? get _discountPercent {
    final double? promo = product.promotionalPrice;
    if (!product.hasPromotion || promo == null) return null;
    return ((product.price - promo) / product.price * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final int? discount = _discountPercent;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    NetworkImageBox(url: product.imageUrl),
                    if (discount != null)
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            AppStrings.discount(discount),
                            style: AppTextStyles.badge,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    PriceBlock(
                      price: product.price,
                      promotionalPrice: product.promotionalPrice,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
