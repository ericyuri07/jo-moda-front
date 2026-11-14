import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/cart_item.dart';
import 'app_card.dart';
import 'network_image_box.dart';
import 'price_block.dart';
import 'quantity_stepper.dart';

/// Item do carrinho em card: foto, nome, tamanho/cor, preço, quantidade e
/// botão de remover.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: AppSizes.cartImageWidth,
              height: AppSizes.cartImageHeight,
              child: NetworkImageBox(url: item.imageUrl),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyStrong,
                      ),
                    ),
                    IconButton(
                      tooltip: AppStrings.removeItemTooltip,
                      visualDensity: VisualDensity.compact,
                      color: AppColors.textSecondary,
                      icon: const Icon(Icons.close, size: AppSizes.iconSm),
                      onPressed: onRemove,
                    ),
                  ],
                ),
                Text(
                  AppStrings.sizeLine(item.size, item.color),
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: PriceBlock(
                        price: item.price,
                        promotionalPrice: item.promotionalPrice,
                        showInstallments: false,
                      ),
                    ),
                    QuantityStepper(
                      compact: true,
                      quantity: item.quantity,
                      maxQuantity: item.stock,
                      onChanged: onQuantityChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
