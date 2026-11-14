import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/admin/admin_categories_screen.dart';
import '../../screens/admin/admin_products_screen.dart';
import '../../screens/admin/product_form_screen.dart';
import '../../screens/auth/admin_sign_in_screen.dart';
import '../../screens/auth/admin_sign_up_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/product/product_detail_screen.dart';
import '../constants/app_strings.dart';
import '../theme/app_spacing.dart';
import 'app_routes.dart';

/// Configuração de navegação, seguindo o fluxograma do protótipo:
///
/// ```
/// /login ⇄ /cadastro
///    └──────► /inicio (Home) ─► /produto/:id ─► /carrinho ─► WhatsApp
///                 └──────────► /admin/produtos (só admin)
///                                  ├ /admin/produtos/novo
///                                  ├ /admin/produtos/:id/editar
///                                  └ /admin/categorias
/// ```
///
/// O estado de login chega por funções (`isSignedIn`, `isAdmin`) e por um
/// [Listenable] genérico, para que o `core/` não precise importar nada de
/// `services/`. Quando [refreshListenable] avisa (login, logout ou sessão
/// expirada), o `redirect` roda de novo.
abstract final class AppRouter {
  static GoRouter create({
    required String initialLocation,
    required Listenable refreshListenable,
    required bool Function() isSignedIn,
    required bool Function() isAdmin,
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      refreshListenable: refreshListenable,
      debugLogDiagnostics: kDebugMode,
      redirect: (context, state) {
        final String location = state.matchedLocation;
        final bool isAuthPage =
            location == AppRoutes.signInPath ||
            location == AppRoutes.signUpPath ||
            location == AppRoutes.adminSignInPath ||
            location == AppRoutes.adminSignUpPath;

        if (!isSignedIn()) return isAuthPage ? null : AppRoutes.signInPath;

        // Já logado não volta para Login/Cadastro: admin vai para o painel.
        if (isAuthPage) {
          return isAdmin() ? AppRoutes.adminProductsPath : AppRoutes.homePath;
        }

        if (location.startsWith(AppRoutes.adminPrefix) && !isAdmin()) {
          return AppRoutes.homePath;
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.signInPath,
          name: AppRoutes.signIn,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: AppRoutes.signUpPath,
          name: AppRoutes.signUp,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.adminSignInPath,
          name: AppRoutes.adminSignIn,
          builder: (context, state) => const AdminSignInScreen(),
        ),
        GoRoute(
          path: AppRoutes.adminSignUpPath,
          name: AppRoutes.adminSignUp,
          builder: (context, state) => const AdminSignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.homePath,
          name: AppRoutes.home,
          builder: (context, state) =>
              HomeScreen(initialQuery: state.uri.queryParameters['q']),
        ),
        GoRoute(
          path: AppRoutes.productPath,
          name: AppRoutes.product,
          builder: (context, state) =>
              ProductDetailScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.cartPath,
          name: AppRoutes.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: AppRoutes.adminProductsPath,
          name: AppRoutes.adminProducts,
          builder: (context, state) => const AdminProductsScreen(),
        ),
        GoRoute(
          path: AppRoutes.adminProductNewPath,
          name: AppRoutes.adminProductNew,
          builder: (context, state) => const ProductFormScreen(),
        ),
        GoRoute(
          path: AppRoutes.adminCategoriesPath,
          name: AppRoutes.adminCategories,
          builder: (context, state) => const AdminCategoriesScreen(),
        ),
        GoRoute(
          path: AppRoutes.adminProductEditPath,
          name: AppRoutes.adminProductEdit,
          builder: (context, state) =>
              ProductFormScreen(productId: state.pathParameters['id']),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              '${AppStrings.routeNotFound}\n${state.uri}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
