import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/app_user.dart';
import '../services/service_locator.dart';
import 'jo_logo.dart';

/// Menu lateral (hambúrguer) da área de compras: cabeçalho escuro com a logo
/// e o usuário. O item de administração só aparece para perfil `admin`.
class ShopDrawer extends StatelessWidget {
  const ShopDrawer({super.key});

  Future<void> _signOut(BuildContext context) async {
    await authService.signOut();
    await cartService.clear();
    if (context.mounted) context.goNamed(AppRoutes.signIn);
  }

  void _go(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    context.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final AppUser? user = authService.currentUser;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              MediaQuery.paddingOf(context).top + AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            decoration: const BoxDecoration(
              color: AppColors.authBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.gold,
                  width: AppSizes.borderWidthSelected,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const JoLogo(size: AppSizes.logoDrawer),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.welcome(user?.name ?? ''),
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textOnDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textOnDarkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text(AppStrings.menuHome),
            onTap: () => _go(context, AppRoutes.home),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text(AppStrings.menuCart),
            onTap: () => _go(context, AppRoutes.cart),
          ),
          if (user?.isAdmin ?? false) ...<Widget>[
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text(AppStrings.menuAdminProducts),
              onTap: () => _go(context, AppRoutes.adminProducts),
            ),
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text(AppStrings.menuAdminCategories),
              onTap: () => _go(context, AppRoutes.adminCategories),
            ),
          ],
          const Spacer(),
          const Divider(),
          SafeArea(
            top: false,
            child: ListTile(
              iconColor: AppColors.danger,
              textColor: AppColors.danger,
              leading: const Icon(Icons.logout),
              title: const Text(AppStrings.menuSignOut),
              onTap: () => _signOut(context),
            ),
          ),
        ],
      ),
    );
  }
}
