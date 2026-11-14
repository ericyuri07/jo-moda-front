import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// Cabeçalho da loja (Home, Produto, Carrinho): faixa escura da marca com
/// menu, nome da loja em dourado e carrinho; embaixo, a busca em pílula.
class ShopHeader extends StatelessWidget {
  const ShopHeader({
    required this.onMenuTap,
    required this.onCartTap,
    required this.searchController,
    required this.cartCount,
    this.onSearchChanged,
    this.onSearchSubmitted,
    super.key,
  });

  final VoidCallback onMenuTap;
  final VoidCallback onCartTap;
  final TextEditingController searchController;
  final int cartCount;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder pill = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      borderSide: BorderSide.none,
    );

    return Container(
      // A faixa escura sobe até atrás da barra de status do celular.
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        MediaQuery.paddingOf(context).top + AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.authBackground,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                tooltip: AppStrings.menuTooltip,
                color: AppColors.gold,
                icon: const Icon(Icons.menu, size: AppSizes.iconLg),
                onPressed: onMenuTap,
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    AppStrings.logoName,
                    style: AppTextStyles.brandName,
                  ),
                ),
              ),
              IconButton(
                tooltip: AppStrings.cartTooltip,
                color: AppColors.gold,
                onPressed: onCartTap,
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  backgroundColor: AppColors.accent,
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: AppSizes.iconLg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.input,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(
                  Icons.search,
                  size: AppSizes.iconSm,
                  color: AppColors.goldDark,
                ),
                fillColor: AppColors.surface,
                border: pill,
                enabledBorder: pill,
                focusedBorder: pill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
