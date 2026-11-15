import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../models/product_variant.dart';
import '../../services/api_exception.dart';
import '../../services/service_locator.dart';
import '../../widgets/app_card.dart';
import '../../widgets/error_state.dart';
import '../../widgets/network_image_box.dart';
import '../../widgets/option_chip.dart';
import '../../widgets/price_block.dart';
import '../../widgets/product_card.dart';
import '../../widgets/quantity_stepper.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shop_scaffold.dart';

/// Detalhes do produto (fluxograma: 4): galeria, cor, tamanho com estoque,
/// preço, quantidade, "Comprar" (adiciona ao carrinho e abre o carrinho),
/// descrição e "Veja também".
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  List<Product> _related = const <Product>[];
  bool _isLoading = true;
  String? _errorMessage;

  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Product product = await productService.getProduct(widget.productId);

      List<Product> related = const <Product>[];
      try {
        related = await productService.getRelated(product);
      } on ApiException {
        related = const <Product>[];
      }

      if (!mounted) return;
      setState(() {
        _product = product;
        _related = related;
        _selectedColor = _defaultColor(product);
        _selectedSize = null;
        _quantity = 1;
        _imageIndex = 0;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(
          () => _errorMessage = e.statusCode == 404
              ? AppStrings.productNotFound
              : e.message,
        );
      }
    } on Object {
      if (mounted) setState(() => _errorMessage = AppStrings.loadError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Primeira cor que ainda tem estoque (ou a primeira, se tudo esgotou).
  String? _defaultColor(Product product) {
    for (final String color in product.colors) {
      if (_colorAvailable(product, color)) return color;
    }
    return product.colors.isEmpty ? null : product.colors.first;
  }

  bool _colorAvailable(Product product, String color) {
    return product.variants.any((v) => v.color == color && v.inStock);
  }

  bool _sizeAvailable(Product product, String size) {
    return product.variants.any(
      (v) => v.color == _selectedColor && v.size == size && v.inStock,
    );
  }

  ProductVariant? _selectedVariant(Product product) {
    for (final ProductVariant v in product.variants) {
      if (v.color == _selectedColor && v.size == _selectedSize) return v;
    }
    return null;
  }

  void _selectColor(Product product, String color) {
    setState(() {
      _selectedColor = color;
      if (_selectedSize != null && !_sizeAvailable(product, _selectedSize!)) {
        _selectedSize = null;
      }
      _quantity = 1;
    });
  }

  void _selectSize(String size) {
    setState(() {
      _selectedSize = size;
      _quantity = 1;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _buy(Product product) async {
    if (product.variants.isEmpty) {
      _showMessage(AppStrings.noVariants);
      return;
    }

    final ProductVariant? variant = _selectedVariant(product);
    if (variant == null || !variant.inStock) {
      _showMessage(AppStrings.chooseSize);
      return;
    }

    await cartService.add(
      CartItem(
        variantId: variant.id,
        productId: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        promotionalPrice: product.promotionalPrice,
        size: variant.size,
        color: variant.color,
        quantity: _quantity,
        stock: variant.stock,
      ),
    );

    if (mounted) context.pushNamed(AppRoutes.cart);
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
      listenable: cartService,
      builder: (context, _) => ShopScaffold(
        cartCount: cartService.totalQuantity,
        user: authService.currentUser,
        onSignOut: signOutAndClearCart,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final String? error = _errorMessage;
    final Product? product = _product;
    if (error != null || product == null) {
      return ErrorState(
        message: error ?? AppStrings.productNotFound,
        onRetry: _load,
      );
    }

    final List<String> gallery = product.galleryUrls;
    final ProductVariant? variant = _selectedVariant(product);
    final int? stock = variant?.stock;
    final bool lowStock =
        stock != null && stock > 0 && stock <= AppSizes.lowStockLimit;

    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: SizedBox(
              height: AppSizes.galleryHeight,
              width: double.infinity,
              child: NetworkImageBox(
                url: gallery.isEmpty ? null : gallery[_imageIndex],
              ),
            ),
          ),
        ),
        if (gallery.length > 1) _buildThumbnails(gallery),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.lg,
            AppSpacing.screenPadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(product.name, style: AppTextStyles.productName),
              const SizedBox(height: AppSpacing.md),
              PriceBlock(
                price: product.price,
                promotionalPrice: product.promotionalPrice,
                large: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (product.colors.isNotEmpty || product.sizes.isNotEmpty)
                AppCard(child: _buildOptions(product)),
              if (lowStock) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.local_fire_department_outlined,
                      size: AppSizes.iconSm,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.stockLeft(stock),
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  QuantityStepper(
                    quantity: _quantity,
                    maxQuantity: variant?.stock ?? AppConfig.maxQuantity,
                    onChanged: (value) => setState(() => _quantity = value),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SizedBox(
                      height: AppSizes.primaryButtonHeight,
                      child: ElevatedButton.icon(
                        onPressed: () => _buy(product),
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text(AppStrings.buyButton),
                      ),
                    ),
                  ),
                ],
              ),
              if ((product.description ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(AppStrings.descriptionLabel),
                const SizedBox(height: AppSpacing.md),
                Text(product.description!, style: AppTextStyles.body),
              ],
              if (_related.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(AppStrings.seeAlso),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
        if (_related.isNotEmpty) _buildRelated(),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildOptions(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (product.colors.isNotEmpty) ...<Widget>[
          const Text(AppStrings.colorLabel, style: AppTextStyles.fieldLabel),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final String color in product.colors)
                OptionChip(
                  label: color,
                  selected: color == _selectedColor,
                  available: _colorAvailable(product, color),
                  onTap: () => _selectColor(product, color),
                ),
            ],
          ),
        ],
        if (product.colors.isNotEmpty && product.sizes.isNotEmpty)
          const SizedBox(height: AppSpacing.lg),
        if (product.sizes.isNotEmpty) ...<Widget>[
          const Text(AppStrings.sizeLabel, style: AppTextStyles.fieldLabel),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final String size in product.sizes)
                OptionChip(
                  label: size,
                  selected: size == _selectedSize,
                  available: _sizeAvailable(product, size),
                  onTap: () => _selectSize(size),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildThumbnails(List<String> gallery) {
    return SizedBox(
      height: AppSizes.thumbSize + AppSpacing.xl,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          0,
        ),
        itemCount: gallery.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => setState(() => _imageIndex = i),
          child: AnimatedContainer(
            duration: AppDurations.selection,
            width: AppSizes.thumbSize,
            height: AppSizes.thumbSize,
            padding: const EdgeInsets.all(AppSpacing.hairline),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: i == _imageIndex ? AppColors.gold : AppColors.border,
                width: i == _imageIndex
                    ? AppSizes.borderWidthSelected
                    : AppSizes.borderWidth,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: NetworkImageBox(url: gallery[i]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRelated() {
    return SizedBox(
      height: AppSizes.relatedListHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          0,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        itemCount: _related.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) => SizedBox(
          width: AppSizes.relatedCardWidth,
          child: ProductCard(
            product: _related[i],
            onTap: () => _openProduct(_related[i]),
          ),
        ),
      ),
    );
  }
}
