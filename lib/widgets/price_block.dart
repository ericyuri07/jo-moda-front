import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';

/// Preço do produto: valor atual (em vermelho quando há promoção), valor
/// original riscado e, opcionalmente, o parcelamento.
class PriceBlock extends StatelessWidget {
  const PriceBlock({
    required this.price,
    this.promotionalPrice,
    this.large = false,
    this.showInstallments = true,
    super.key,
  });

  final double price;
  final double? promotionalPrice;
  final bool large;
  final bool showInstallments;

  @override
  Widget build(BuildContext context) {
    final double? promo = promotionalPrice;
    final bool hasPromotion = promo != null && promo < price;
    final double current = hasPromotion ? promo : price;

    final TextStyle strikeStyle = large
        ? AppTextStyles.priceLargeStrike
        : AppTextStyles.priceStrike;
    final TextStyle currentStyle = hasPromotion
        ? (large
              ? AppTextStyles.priceLargeHighlight
              : AppTextStyles.priceHighlight)
        : (large ? AppTextStyles.priceLarge : AppTextStyles.price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (hasPromotion) ...<Widget>[
              Text(Formatters.currency(price), style: strikeStyle),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: Text(
                Formatters.currency(current),
                overflow: TextOverflow.ellipsis,
                style: currentStyle,
              ),
            ),
          ],
        ),
        if (showInstallments)
          Text(
            Formatters.installment(current),
            style: AppTextStyles.captionSmall,
          ),
      ],
    );
  }
}
