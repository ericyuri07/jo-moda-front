/// Nomes e caminhos das rotas. Navegue sempre por nome:
/// `context.goNamed(AppRoutes.home)`.
abstract final class AppRoutes {
  /// Abertura animada com a logo; sempre a primeira tela do app.
  static const String splash = 'splash';
  static const String splashPath = '/';

  static const String signIn = 'sign-in';
  static const String signInPath = '/login';

  static const String signUp = 'sign-up';
  static const String signUpPath = '/cadastro';

  static const String adminSignIn = 'admin-sign-in';
  static const String adminSignInPath = '/login-adm';

  static const String adminSignUp = 'admin-sign-up';
  static const String adminSignUpPath = '/cadastro-adm';

  static const String home = 'home';
  static const String homePath = '/inicio';

  static const String product = 'product';
  static const String productPath = '/produto/:id';

  static const String cart = 'cart';
  static const String cartPath = '/carrinho';

  /// Prefixo de todas as rotas restritas a administradores.
  static const String adminPrefix = '/admin';

  static const String adminProducts = 'admin-products';
  static const String adminProductsPath = '/admin/produtos';

  static const String adminProductNew = 'admin-product-new';
  static const String adminProductNewPath = '/admin/produtos/novo';

  static const String adminCategories = 'admin-categories';
  static const String adminCategoriesPath = '/admin/categorias';

  static const String adminProductEdit = 'admin-product-edit';
  static const String adminProductEditPath = '/admin/produtos/:id/editar';

  /// Parâmetro do login/cadastro com a tela da loja para onde voltar depois.
  static const String returnParam = 'voltar';

  /// Destino de volta pedido em [uri]; só aceita telas abertas da loja.
  static String? returnPathFrom(Uri uri) {
    final String? path = uri.queryParameters[returnParam];
    if (path == null) return null;

    final bool isShopPage =
        path == homePath || path == cartPath || path.startsWith('/produto/');
    return isShopPage ? path : null;
  }

  /// Parâmetros que fazem o login/cadastro voltar para [path].
  static Map<String, String> returnTo(String? path) => <String, String>{
    returnParam: ?path,
  };
}
