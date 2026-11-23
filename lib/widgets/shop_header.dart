import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_curves.dart';
import '../core/theme/app_durations.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import 'jo_logo.dart';

/// Cabeçalho da loja (Home, Produto, Carrinho): faixa branca com menu, logo
/// e carrinho, e a busca logo abaixo. O número do carrinho "pula" quando
/// muda.
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
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xs,
        MediaQuery.paddingOf(context).top + AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: AppSizes.borderWidth,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                tooltip: AppStrings.menuTooltip,
                color: AppColors.textPrimary,
                icon: const Icon(Icons.menu_rounded, size: AppSizes.iconLg),
                onPressed: onMenuTap,
              ),
              const Expanded(
                child: Center(child: JoLogo(size: AppSizes.logoHeader)),
              ),
              IconButton(
                tooltip: AppStrings.cartTooltip,
                color: AppColors.textPrimary,
                onPressed: onCartTap,
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.textOnDark,
                  label: AnimatedSwitcher(
                    duration: AppDurations.selection,
                    switchInCurve: AppCurves.standard,
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Text('$cartCount', key: ValueKey<int>(cartCount)),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: AppSizes.iconLg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.input,
              cursorColor: AppColors.primary,
              decoration: const InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: Icon(Icons.search_rounded, size: AppSizes.iconSm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
