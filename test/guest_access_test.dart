import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jo_modas/core/constants/app_strings.dart';
import 'package:jo_modas/core/routes/app_router.dart';
import 'package:jo_modas/core/routes/app_routes.dart';
import 'package:jo_modas/core/theme/app_theme.dart';
import 'package:jo_modas/models/cart_item.dart';
import 'package:jo_modas/screens/auth/admin_sign_in_screen.dart';
import 'package:jo_modas/screens/auth/sign_in_screen.dart';
import 'package:jo_modas/screens/auth/sign_up_screen.dart';
import 'package:jo_modas/screens/cart/cart_screen.dart';
import 'package:jo_modas/screens/home/home_screen.dart';
import 'package:jo_modas/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ValueNotifier<bool> signedIn;
  late GoRouter router;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    signedIn = ValueNotifier<bool>(false);
    checkoutDraft.clear();
    await cartService.clear();
  });

  tearDown(() {
    router.dispose();
    signedIn.dispose();
  });

  Future<void> settle(WidgetTester tester) async {
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> open(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    router = AppRouter.create(
      initialLocation: location,
      refreshListenable: signedIn,
      isSignedIn: () => signedIn.value,
      isAdmin: () => false,
    );
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
    await settle(tester);
  }

  testWidgets('Visitante abre a vitrine sem login', (tester) async {
    await open(tester, AppRoutes.homePath);

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Visitante não entra na administração', (tester) async {
    await open(tester, AppRoutes.adminProductsPath);

    expect(find.byType(AdminSignInScreen), findsOneWidget);
  });

  testWidgets('Menu do visitante mostra Entrar, não Sair', (tester) async {
    await open(tester, AppRoutes.cartPath);

    await tester.tap(find.byTooltip(AppStrings.menuTooltip));
    await settle(tester);
    expect(find.text(AppStrings.menuSignOut), findsNothing);

    await tester.tap(find.text(AppStrings.menuSignIn));
    await settle(tester);
    expect(find.byType(SignInScreen), findsOneWidget);

    await tester.tap(find.byTooltip(AppStrings.backToShop));
    await settle(tester);
    expect(find.byType(CartScreen), findsOneWidget);
  });

  testWidgets('Finalizar pede login e volta ao carrinho com o endereço', (
    tester,
  ) async {
    await cartService.add(
      const CartItem(
        variantId: 'v1',
        productId: 'p1',
        name: 'Vestido',
        size: 'M',
        color: 'Preto',
        price: 100,
        quantity: 1,
        stock: 5,
      ),
    );
    await open(tester, AppRoutes.cartPath);

    final Finder fields = find.descendant(
      of: find.byType(Form),
      matching: find.byType(EditableText),
    );
    await tester.enterText(fields.at(0), '84010000');
    await tester.enterText(fields.at(1), 'Rua das Flores');
    await tester.enterText(fields.at(2), '123');
    await tester.enterText(fields.at(3), 'PR');
    await tester.enterText(fields.at(4), 'Centro');
    await settle(tester);

    await tester.tap(find.text(AppStrings.sendWhatsapp));
    await settle(tester);
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.text(AppStrings.signInToOrder), findsOneWidget);

    await tester.tap(find.text(AppStrings.noAccountLink));
    await settle(tester);
    expect(find.byType(SignUpScreen), findsOneWidget);

    signedIn.value = true;
    await settle(tester);

    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text('Vestido'), findsOneWidget);
    expect(find.text('Rua das Flores'), findsOneWidget);
    expect(find.text('Centro'), findsOneWidget);
  });

  testWidgets('Quem entra sem vir do carrinho vai para a vitrine', (
    tester,
  ) async {
    await open(tester, AppRoutes.signInPath);

    signedIn.value = true;
    await settle(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  test('Volta do login só aceita telas da loja', () {
    router = GoRouter(
      routes: <RouteBase>[
        GoRoute(path: '/', builder: (_, _) => const SizedBox()),
      ],
    );
    String? parse(String path) => AppRoutes.returnPathFrom(
      Uri(path: '/login', queryParameters: AppRoutes.returnTo(path)),
    );

    expect(parse(AppRoutes.cartPath), AppRoutes.cartPath);
    expect(parse('/produto/1'), '/produto/1');
    expect(parse(AppRoutes.adminProductsPath), isNull);
    expect(parse('https://exemplo.com'), isNull);
  });
}
