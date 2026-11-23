import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/api_exception.dart';
import '../../services/service_locator.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/home_banner.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_card_skeleton.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shop_scaffold.dart';
import '../../widgets/skeleton.dart';

/// Home (fluxograma: 3): banner, categorias e vitrine de produtos.
/// Tudo vem da API; a busca e o filtro de categoria agem sobre a lista.
class HomeScreen extends StatefulWidget {
  const HomeScreen({this.initialQuery, super.key});

  /// Texto de busca vindo de outra tela (`/inicio?q=...`).
  final String? initialQuery;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  List<Category> _categories = const <Category>[];
  List<Product> _products = const <Product>[];
  String? _selectedCategoryId;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Future<List<Category>> categoriesFuture = categoryService
          .getCategories();
      final Future<List<Product>> productsFuture = productService.getProducts();
      await Future.wait<Object>(<Future<Object>>[
        categoriesFuture,
        productsFuture,
      ]);

      final List<Category> categories = await categoriesFuture;
      final List<Product> products = await productsFuture;

      if (!mounted) return;
      setState(() {
        _categories = categories;
        _products = products;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } on Object {
      if (mounted) setState(() => _errorMessage = AppStrings.storeLoadError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Product> get _visibleProducts {
    final String query = _searchController.text.trim().toLowerCase();

    return _products.where((Product p) {
      final bool inCategory =
          _selectedCategoryId == null || p.categoryId == _selectedCategoryId;
      final bool matchesSearch =
          query.isEmpty || p.name.toLowerCase().contains(query);
      return inCategory && matchesSearch;
    }).toList();
  }

  List<Product> get _bannerProducts {
    final List<Product> featured = _products
        .where((Product p) => p.featured)
        .take(4)
        .toList();
    return featured.isNotEmpty ? featured : _products.take(4).toList();
  }

  /// Foto enviada pelo admin; sem ela, a foto do primeiro produto da
  /// categoria (e, sem produto, o círculo mostra a inicial).
  String? _categoryImage(Category category) {
    final String? own = category.imageUrl;
    if (own != null && own.isNotEmpty) return own;

    for (final Product p in _products) {
      if (p.categoryId == category.id) return p.imageUrl;
    }
    return null;
  }

  void _openProduct(Product product) {
    context.pushNamed(
      AppRoutes.product,
      pathParameters: <String, String>{'id': product.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[cartService, authService]),
      builder: (context, _) => ShopScaffold(
        cartCount: cartService.totalQuantity,
        user: authService.currentUser,
        onSignOut: signOutAndClearCart,
        searchController: _searchController,
        onSearchChanged: (_) => setState(() {}),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildSkeleton();

    final String? error = _errorMessage;
    if (error != null) {
      return ErrorState(message: error, onRetry: _load);
    }

    final List<Product> products = _visibleProducts;

    return RefreshIndicator(
      onRefresh: _load,
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          SliverToBoxAdapter(
            child: FadeSlideIn(
              child: HomeBanner(products: _bannerProducts, onTap: _openProduct),
            ),
          ),
          const SliverToBoxAdapter(
            child: FadeSlideIn(
              index: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.xl,
                  AppSpacing.screenPadding,
                  AppSpacing.lg,
                ),
                child: SectionHeader(AppStrings.featuredTitle),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(
            child: FadeSlideIn(
              index: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.xl,
                  AppSpacing.screenPadding,
                  AppSpacing.lg,
                ),
                child: SectionHeader(
                  AppStrings.storeTitle,
                  trailing: AppStrings.productCount(products.length),
                ),
              ),
            ),
          ),
          if (products.isEmpty)
            const SliverToBoxAdapter(
              child: EmptyState(message: AppStrings.noProducts),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => FadeSlideIn(
                    key: ValueKey<String>(products[i].id),
                    index: i,
                    child: ProductCard(
                      product: products[i],
                      onTap: () => _openProduct(products[i]),
                    ),
                  ),
                  childCount: products.length,
                ),
                gridDelegate: _gridDelegate,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }

  static const SliverGridDelegate _gridDelegate =
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: AppSizes.productCardAspectRatio,
      );

  /// Vitrine "fantasma" pulsando enquanto a API responde.
  Widget _buildSkeleton() {
    return CustomScrollView(
      key: const ValueKey<String>('skeleton'),
      physics: const NeverScrollableScrollPhysics(),
      slivers: <Widget>[
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.lg,
            AppSpacing.screenPadding,
            AppSpacing.xl,
          ),
          sliver: SliverToBoxAdapter(
            child: Skeleton(
              height: AppSizes.bannerHeight,
              radius: AppRadius.xl,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => const ProductCardSkeleton(),
              childCount: 4,
            ),
            gridDelegate: _gridDelegate,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: AppSizes.categoryListHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, i) {
          final Category category = _categories[i];
          final bool selected = category.id == _selectedCategoryId;

          return FadeSlideIn(
            index: i + 1,
            child: CategoryTile(
              name: category.name,
              imageUrl: _categoryImage(category),
              selected: selected,
              onTap: () => setState(
                () => _selectedCategoryId = selected ? null : category.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
