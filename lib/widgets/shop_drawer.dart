import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_sizes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/app_user.dart';
import 'fade_slide_in.dart';
import 'jo_logo.dart';

/// Menu lateral (hambúrguer) da área de compras: logo, usuário e os itens
/// entrando em sequência. O item de administração só aparece para perfil
/// `admin`; visitante vê "Entrar" no lugar de "Sair".
class ShopDrawer extends StatelessWidget {
  const ShopDrawer({required this.user, required this.onSignOut, super.key});

  final AppUser? user;
  final Future<void> Function() onSignOut;

  Future<void> _signOut(BuildContext context) async {
    final GoRouter router = GoRouter.of(context);
    Navigator.of(context).pop();
    await onSignOut();
    router.goNamed(AppRoutes.home);
  }

  void _signIn(BuildContext context) {
    final String from = GoRouterState.of(context).matchedLocation;
    Navigator.of(context).pop();
    context.goNamed(
      AppRoutes.signIn,
      queryParameters: AppRoutes.returnTo(from),
    );
  }

  void _go(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    context.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final AppUser? user = this.user;

    final List<Widget> items = <Widget>[
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
    ];

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              MediaQuery.paddingOf(context).top + AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            child: FadeSlideIn(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const JoLogo(size: AppSizes.logoDrawer),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    user == null
                        ? AppStrings.welcomeGuest
                        : AppStrings.welcome(user.name),
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    user?.email ?? AppStrings.guestHint,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          for (int i = 0; i < items.length; i++)
            FadeSlideIn(index: i + 1, child: items[i]),
          const Spacer(),
          const Divider(),
          SafeArea(
            top: false,
            child: user == null
                ? ListTile(
                    leading: const Icon(Icons.login_rounded),
                    title: const Text(AppStrings.menuSignIn),
                    onTap: () => _signIn(context),
                  )
                : ListTile(
                    iconColor: AppColors.danger,
                    textColor: AppColors.danger,
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text(AppStrings.menuSignOut),
                    onTap: () => _signOut(context),
                  ),
          ),
        ],
      ),
    );
  }
}
